FROM rocker/verse:3.3.1
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

RUN apt-get update && apt-get install -y libgdal-dev libproj-dev libgsl0-dev

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
    shiny flexdashboard pomp

RUN R -e "devtools::install_github('dashboardsfhi/dashboardgraphs')"
RUN R -e "devtools::install_github('bwlewis/doRedis')"
RUN R -e "devtools::install_github('raubreywhite/RAWmisc') "

RUN echo "/usr/local/lib/R/lib" > /etc/ld.so.conf.d/libR.conf
RUN ldconfig

RUN apt-get update \
  && apt-get install -y sshpass


