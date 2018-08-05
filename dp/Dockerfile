#FROM nvcr.io/nvidia/tensorflow:18.04-py3
#FROM tensorflow/tensorflow:1.10.0-rc1-py3
ARG FROM_IMAGE=FROM_IMAGE
FROM ${FROM_IMAGE}

LABEL maintainer="Kai Lichtenberg <kai@sentin.ai>"

#Arguments
ARG USER="docker"
ARG myUID="1000"
ARG myGID="1000"

#Specifiy R and Keras Version
ENV R_BASE_VERSION=3.5.1
ENV KERAS_VERSION=2.1.5

#Set a user 
RUN groupadd --gid "${myGID}" "${USER}" \
  && useradd \
    --uid ${myUID} \
    --gid ${myGID} \
    --create-home \
    --shell /bin/bash \
    ${USER}

#Install packages needed
RUN apt-get update \ 
  && apt-get install -y --no-install-recommends \
    ed \
    locales \
    vim-tiny \
    fonts-texgyre \
    gnupg2 \
    libcurl4-openssl-dev \
    libssl-dev \
    libssh2-1-dev \
    sudo \
    virtualenv \
  && rm -rf /var/lib/apt/lists/*

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
        && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default 

#Add key
RUN apt-key adv --keyserver keyserver.ubuntu.com:80 --recv-keys 8B48AD6246925553 7638D0442B90D010 04EE7237B7D453EC
#RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 \
#  && gpg -a --export E084DAB9 | apt-key add -

## Now install R and littler, and create a link for littler in /usr/local/bin
RUN apt-get update \
	&& apt-get install -t unstable -y --allow-unauthenticated --no-install-recommends \
		littler \
                r-cran-littler \
		r-base=${R_BASE_VERSION}-* \
		r-base-dev=${R_BASE_VERSION}-* \
		r-recommended=${R_BASE_VERSION}-* \
	&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/lib/rstudio-server/bin:$PATH

## Download and install RStudio server & dependencies
## Attempts to get detect latest version, otherwise falls back to version given in $VER
## Symlink pandoc, pandoc-citeproc so they are available system-wide
RUN apt-get update \
  && echo docker:docker | chpasswd \
  && apt-get install -y --no-install-recommends --allow-unauthenticated \
    apt-utils \
    file \
    git \
    libapparmor1 \
    libcurl4-openssl-dev \
    libedit2 \
    libssl-dev \
    lsb-release \
    psmisc \
    python-setuptools \
    sudo \
    wget \
    libssl1.0.0 \
  && RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
  && wget -q http://download2.rstudio.org/rstudio-server-${RSTUDIO_LATEST}-amd64.deb \
  && dpkg -i rstudio-server-${RSTUDIO_LATEST}-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  ## RStudio wants an /etc/R, will populate from $R_HOME/etc
  && mkdir -p /etc/R \
  && mkdir /usr/local/lib/R/etc/ \
  ## Write config files in $R_HOME/etc
  && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Need to configure non-root user for RStudio
  && useradd rstudio \
  && echo "rstudio:rstudio" | chpasswd \
	&& mkdir /home/rstudio \
	&& chown rstudio:rstudio /home/rstudio \
	&& addgroup rstudio staff \
  ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
  &&  echo 'rsession-which-r=/usr/bin/R' >> /etc/rstudio/rserver.conf \
  ## use more robust file locking to avoid errors when using shared volumes:
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \ 
  ## configure git not to request password each time 
  && git config --system credential.helper 'cache --timeout=3600' \
  && git config --system push.default simple \
  ## Set up S6 init system
  && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && mkdir -p /etc/services.d/rstudio \
  && echo '#!/usr/bin/with-contenv bash \
           \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
           > /etc/services.d/rstudio/run \
   && echo '#!/bin/bash \
           \n rstudio-server stop' \
           > /etc/services.d/rstudio/finish \
  && mkdir -p /home/rstudio/.rstudio/monitored/user-settings \
  && echo 'alwaysSaveHistory="0" \
          \nloadRData="0" \
          \nsaveAction="0"' \
          > /home/rstudio/.rstudio/monitored/user-settings/user-settings \
  && chown -R rstudio:rstudio /home/rstudio/.rstudio

COPY userconf.sh /etc/cont-init.d/userconf
# running with "-e ADD=shiny" adds shiny server
COPY add_shiny.sh /etc/cont-init.d/add

COPY pam-helper.sh /usr/lib/rstudio-server/bin/pam-helper

ARG USER="rstudio"

#Install tensorflow and keras
ENV WORKON_HOME=/home/${USER}/.virtualenvs

RUN install2.r devtools remotes \
  && installGithub.r rstudio/tensorflow \
  && installGithub.r rstudio/keras \
  && virtualenv --system-site-packages /home/${USER}/.virtualenvs/r-tensorflow --python=python3.5 \
  && /bin/bash -c "cd /home/${USER}/.virtualenvs/r-tensorflow/bin/; \
     source activate; \
     pip3 --no-cache-dir install keras"

EXPOSE 8787

CMD ["/init"]