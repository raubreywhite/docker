FROM debian:stretch

MAINTAINER "Patrick O'Doherty <p@trickod.com>"

EXPOSE 9001
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install gnupg apt-transport-https

ADD repos /etc/apt/sources.list.d/test1234
RUN gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
RUN apt-get -y install obfsproxy openssl tor openssh-server

# tor-arm does not work in Docker container:
# _curses.error: setupterm: could not find terminal
# Install outside of the Docker container if required.

WORKDIR /var/lib/tor

ADD ./torrc /etc/tor/torrc
# Allow you to upgrade your relay without having to regenerate keys
# VOLUME /var/lib/tor

VOLUME /.tor

# Generate a random nickname for the relay
RUN echo "Nickname docker$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> /etc/torrc

#CMD /usr/bin/tor -f /etc/torrc

RUN mkdir -p /var/lib/tor/hidden-service
RUN chown -R root:root /var/lib/tor/hidden-service
RUN chmod -R 600 /var/lib/tor/hidden-service
VOLUME /var/lib/tor/hidden-service
ADD ./torrc /etc/torrc
ADD ./start-tor /bin/start-tor
CMD /bin/start-tor
