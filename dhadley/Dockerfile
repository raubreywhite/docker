FROM rocker/verse:3.4.0
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

# include new repo
RUN sed -i "s/CRAN/raubreywhite=\'https:\\/\\/raubreywhite.github.io\\/drat\\/\',CRAN/" /usr/local/lib/R/etc/Rprofile.site

RUN apt-get update && apt-get install -y libgdal-dev libproj-dev libgsl0-dev

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
  && install2.r --error --repos $MRAN \
    data.table

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
    doSNOW


RUN echo "/usr/local/lib/R/lib" > /etc/ld.so.conf.d/libR.conf
RUN ldconfig

RUN apt-get update \
  && apt-get install -y sshpass

## NEWER STUFF THAT NEEDS TO BE INSTALLED FROM GITHUB
RUN R -e "devtools::install_github('bwlewis/doRedis', ref='e4c1a81aa6bd0e4bfba2a7b465f08f822fd8c0d3')"
RUN R -e "devtools::install_github('Appsilon/shiny.router',ref='7d9bc757ea31a1fe8faea6a5817c8adda97a0be0')"
RUN R -e "devtools::install_github('r-lib/processx', ref='4bf780ff168cef0086b89251b6348722b4f9ff67')"
RUN R -e "devtools::install_github('tidyverse/ggplot2', ref='32e699e0bb6ff2be9212e32ad1f6b126bf225f18')"
RUN R -e "devtools::install_github('stan-dev/projpred', ref='d9a59c432899d2c3086623302188eb140bee2e21')"


RUN R -e "devtools::install_github('yihui/knitr')"
RUN R -e "devtools::install_github('rstudio/bookdown')"
RUN R -e "devtools::install_github('rstudio/reticulate')"

RUN apt-get -y install  texlive-xetex

## TENSORFLOW

RUN apt-get install -y python3-pip python3-dev
RUN pip3 install --upgrade pip
RUN pip3 install tensorflow

RUN R -e "Sys.setenv(TENSORFLOW_PYTHON_VERSION=3);install.packages('tensorflow')"

## Custom libraries
RUN . /etc/environment \ 
  && install2.r --error --deps TRUE \
    RAWmisc \
    fhi

## preferences to stop timing out
COPY rsession.conf /etc/rstudio/rsession.conf
