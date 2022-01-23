
ARG R_MAJOR=3.6
ARG GITHUB_PAT=dummy

## ======================================================================
## Build all dependencies of a static curl package first
## ======================================================================

FROM rhub/r-minimal:${R_MAJOR}

WORKDIR /root

# system requirements -----------------------------

RUN installr -c -a "linux-headers bash"

# zlib --------------------------------------------

RUN wget https://www.zlib.net/zlib-1.2.11.tar.gz
RUN tar xzf zlib-*.tar.gz && rm zlib-*.tar.gz
RUN cd zlib-* &&                                    \
    CFLAGS=-fPIC ./configure --static &&            \
    make &&                                         \
    make install

# openssl -----------------------------------------

RUN wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz
RUN tar xzf openssl-*.tar.gz && rm openssl-*.tar.gz
RUN apk add perl linux-headers
RUN cd openssl-* &&                                 \
    ./config no-shared &&                           \
    make &&                                         \
    make install

# libnghttp2 --------------------------------------

RUN wget https://github.com/nghttp2/nghttp2/releases/download/v1.40.0/nghttp2-1.40.0.tar.gz
RUN tar xzf nghttp2-*.tar.gz && rm nghttp2-*.tar.gz
RUN cd nghttp2-* &&                                 \
    ./configure --enable-static --disable-shared && \
    make &&                                         \
    make install

# libcurl now -------------------------------------

RUN wget https://curl.haxx.se/download/curl-7.68.0.tar.gz
RUN tar xzf curl-*.tar.gz && rm curl-*.tar.gz
RUN apk add pkgconfig
RUN cd curl-* && \
    ./configure --enable-static --disable-shared   \
        --with-nghttp2=/usr/local/ &&              \
    make &&                                        \
    make install

## ======================================================================
## set up static compilation
## ======================================================================

RUN mkdir -p /root/.R
COPY linux/Makevars /root/.R/Makevars

## ======================================================================
## pkgdepends
## ======================================================================

# Need a proper cp command for older R versions
RUN apk add coreutils findutils

RUN GITHUB_PAT=${GITHUB_PAT} installr r-lib/pkgdepends

## ======================================================================
## pak
## ======================================================================

COPY linux/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
