FROM rocker/verse:3.3.2
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

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
    ggrepel lme4 arm gmailr pander httpuv

RUN install2.r --error --repos https://www.math.ntnu.no/inla/R/stable --deps FALSE \
  INLA

RUN apt-get install -y jags

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    surveillance

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    munsell RColorBrewer labeling htmltools evaluate \
    R.utils openxlsx splitstackshape

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    corrr ggdendro ClustOfVar \
    dendextend plumber knitcitations bibtex brew Hmisc

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    Gmisc Greg htmlTable ggvis Formula roxygen2 packrat \
    rms survey miniCRAN MatrixModels 

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    shiny flexdashboard pomp xgboost directlabels

RUN . /etc/environment \ 
  && install2.r --error --repos $MRAN --deps TRUE \
    rstan shinystan ineq lomb

RUN echo "/usr/local/lib/R/lib" > /etc/ld.so.conf.d/libR.conf
RUN ldconfig

RUN apt-get update \
  && apt-get install -y sshpass

## VIM-SLIME

RUN apt-get install -y vim curl
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

COPY .vimrc /root/.vimrc
COPY .screenrc /root/.screenrc

RUN cd ~/.vim/bundle && \
git clone git://github.com/jpalardy/vim-slime.git

RUN apt-get install -y screen

## NEWER STUFF THAT NEEDS TO BE INSTALLED FROM GITHUB
RUN R -e "install.packages('rhandsontable')"
RUN R -e "devtools::install_github('dashboardsfhi/dashboardgraphs')"
RUN R -e "devtools::install_github('bwlewis/doRedis')"
RUN R -e "devtools::install_github('Appsilon/shiny.router')"
RUN R -e "devtools::install_github('ThomasSiegmund/D3TableFilter')"

RUN R -e "devtools::install_github('yihui/knitr')"
RUN R -e "devtools::install_github('rstudio/bookdown')"
RUN R -e "devtools::install_github('rstudio/reticulate')"
RUN R -e "install.packages(c('rmarkdown'), repo = 'https://mran.microsoft.com/snapshot/2017-04-01/')"
RUN R -e "install.packages('data.table', type = 'source', repos = 'http://Rdatatable.github.io/data.table')"

RUN apt-get -y install  texlive-xetex

## TENSORFLOW

RUN apt-get install -y python3-pip python3-dev
RUN pip3 install --upgrade pip
RUN pip3 install tensorflow

RUN R -e "Sys.setenv(TENSORFLOW_PYTHON_VERSION=3);devtools::install_github('rstudio/tensorflow')"

## RAWMISC
RUN R -e "devtools::install_github('raubreywhite/RAWmisc')"
