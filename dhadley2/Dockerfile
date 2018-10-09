FROM rocker/verse:3.5.0
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

#COPY profile /etc/profile
#COPY rsession-profile /etc/rstudio/rsession-profile
#COPY rserver.conf /etc/rstudio/rserver.conf

RUN ls /etc/cont-init.d/
RUN sed -i '/exit 1/d' /etc/cont-init.d/userconf

#RUN echo Sys.setenv\(PATH=\"$PATH\"\) >> /usr/local/lib/R/etc/Rprofile.site