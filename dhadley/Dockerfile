FROM rocker/verse:3.4.1
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

########################
######## OPENCPU INSTALL

ENV BRANCH 2.0.6

# Install.
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y wget make devscripts apache2-dev apache2 libapreq2-dev r-base r-base-dev libapparmor-dev libcurl4-openssl-dev libprotobuf-dev protobuf-compiler xvfb xauth xfonts-base curl libssl-dev libxml2-dev libicu-dev pkg-config libssh2-1-dev locales apt-utils && \
  useradd -ms /bin/bash builder

# Note: this is different from Ubuntu (c.f. 'language-pack-en-base')
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

USER builder

RUN \
  cd ~ && \
  wget https://github.com/opencpu/opencpu-server/archive/v${BRANCH}.tar.gz && \
  tar xzf v${BRANCH}.tar.gz && \
  cd opencpu-server-${BRANCH} && \
  dpkg-buildpackage -us -uc

RUN \
  apt-get install -y libapache2-mod-r-base && \
  dpkg -i /home/builder/opencpu-lib_*.deb && \
  dpkg -i /home/builder/opencpu-server_*.deb
# RUN apt-get update && apt-get install -y ppa:opencpu/jq libjq-dev

########################
## NORMAL INSTALLATION

# include new repo
RUN sed -i "s/CRAN/raubreywhite=\'https:\\/\\/raubreywhite.github.io\\/drat\\/\',CRAN/" /usr/local/lib/R/etc/Rprofile.site
RUN sed -i "1s/^/dratRepo=\'\\/git\\/drat\\/\'\n/" /usr/local/lib/R/etc/Rprofile.site

RUN apt-get update && apt-get install -y libgdal-dev libproj-dev libgsl0-dev
RUN apt-get update && apt-get install -y ncftp ftp cron sshpass
RUN apt-get update && apt-get install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev

# data.table doesn't like clang
RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN \
    data.table \
    influenceR \
    gower

# Install clang to use as compiler
# clang seems to be more memory efficient with the templates than g++
# with g++ rstan cannot compile on docker hub due to memory issues
RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
                   clang

# Global site-wide config
RUN mkdir -p $HOME/.R/ \
    && echo "\nCXX=clang++ -ftemplate-depth-256\n" >> $HOME/.R/Makevars \
    && echo "CC=clang\n" >> $HOME/.R/Makevars \
    && echo "CXXFLAGS += -Os\n" >> $HOME/.R/Makevars

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    ggrepel \
    lme4 \
    arm \
    gmailr \
    pander \
    httpuv

RUN install2.r --error --repos https://www.math.ntnu.no/inla/R/stable --deps FALSE \
  INLA

RUN apt-get install -y jags

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    surveillance \
    munsell \
    RColorBrewer \
    labeling \
    htmltools \
    evaluate \
    R.utils \
    openxlsx \
    splitstackshape \
    corrr \
    ggdendro \
    ClustOfVar \
    dendextend \
    plumber \
    knitcitations \
    bibtex \
    brew \
    Hmisc \
    Gmisc \
    Greg \
    htmlTable \
    ggvis \
    Formula \
    roxygen2 \
    packrat \
    rms \
    survey \
    miniCRAN \
    MatrixModels \
    shiny \
    flexdashboard \
    pomp \
    xgboost \
    directlabels \
    rstan \
    shinystan \
    ineq \
    lomb \
    rmarkdown \
    shinyBS \
    rgeolocate \
    glm2 \
    zip \
    doSNOW \
    drat \
    profvis \
    glmnet \
    glmnetUtils \
    pscl \
    knitr \
    bookdown \
    reticulate \
    processx \
    survminer \
    geojsonio

## DRAT PACKAGES
RUN . /etc/environment \ 
  && install2.r --error \
  RAWmisc \
  fhi \
  momo \
  sykdomspuls \
  normomo \
  reporttb \
  msis

RUN echo "/usr/local/lib/R/lib" > /etc/ld.so.conf.d/libR.conf
RUN ldconfig

## NEWER STUFF THAT NEEDS TO BE INSTALLED FROM GITHUB
RUN R -e "devtools::install_github('Appsilon/shiny.router',ref='7d9bc757ea31a1fe8faea6a5817c8adda97a0be0')"
RUN R -e "devtools::install_github('stan-dev/projpred', ref='d9a59c432899d2c3086623302188eb140bee2e21')"
RUN R -e "devtools::install_github('r-lib/testthat')"

RUN apt-get -y install  texlive-xetex

## TENSORFLOW

RUN apt-get install -y python3-pip python3-dev
RUN pip3 install --upgrade pip
RUN pip3 install tensorflow
RUN pip3 install junit-xml

RUN R -e "Sys.setenv(TENSORFLOW_PYTHON_VERSION=3);install.packages('tensorflow')"

## preferences to stop timing out
COPY rsession.conf /etc/rstudio/rsession.conf
