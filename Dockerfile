FROM ubuntu
MAINTAINER onohr <hiroyuki.ono.jc@renesas.com>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN sed -i".bak" -e 's|//archive.ubuntu.com|//ftp.riken.go.jp/Linux|g' /etc/apt/sources.list && cat /etc/apt/sources.list
RUN apt-get -qq update && apt-get -y upgrade && \
    apt-get install -y wget tar perl fontconfig && \
    apt-get autoremove && apt-get autoclean && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar -xvf *.tar.gz
RUN cd install-tl-* && \
    wget --no-check-certificate https://github.com/leodido/dockerfiles/raw/master/texlive:2014/full.profile && \
    ./install-tl --profile full.profile && \
    cd .. && rm -rf install-tl-*

# RUN apt-get -y install texlive texlive-lang-cjk texlive-fonts-recommended texlive-fonts-extra && \
#     apt-get -y install texlive texlive-lang-cjk texlive-fonts-recommended texlive-fonts-extra && \
#     apt-get install -f && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND dialog
CMD /bin/bash
