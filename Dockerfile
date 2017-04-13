FROM debian:jessie

RUN mkdir opt/translation-server
WORKDIR opt/translation-server

# Get dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends git nodejs python \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
	&& apt-get clean

COPY . .
RUN git submodule update --init --recursive

# Generate csljson
RUN ./xmltojson.py ./csl ./csljson \
    && ./xmltojson.py ./csl-locales ./csljson-locales

EXPOSE 8085

ENTRYPOINT nodejs lib/citeServer.js

