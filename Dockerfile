FROM ubuntu
MAINTAINER Yamamoto Yu 

ENV PKG="${PKG} wget tar unzip"
ENV PKG="${PKG} fontconfig fonts-takao-pgothic fonts-takao-gothic fonts-takao-mincho"
RUN apt-get -qq update && \\
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    ( apt-get -qq --force-yes -y --no-install-recommends install language-pack-ja || \
      apt-get -qq --force-yes -y --no-install-recommends install language-pack-ja=1:14.04+20140410 ) && \
    dpkg-reconfigure -f noninteractive locales && \
    if [ "${PKG}" ];then \
       apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y --no-install-recommends upgrade && \
       apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y --no-install-recommends install ${PKG} ;fi && \
    apt-get --force-yes -y --no-install-recommends install && \
    apt-get autoremove && apt-get autoclean && apt-get clean && \
    rm -rf "/var/cache/apt/archives/*" "/var/lib/apt/lists/*" && \
    echo 'debconf debconf/frontend select Dialog' | debconf-set-selections

ENV TERM=xterm LANGUAGE=ja_JP:ja LANG=ja_JP.UTF-8 LC_TIME=POSIX
RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir -p install-tl
ADD texlive2015.profile install-tl/

RUN wget -nv -O install-tl.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar -xzf install-tl.tar.gz -C install-tl --strip-components=1 &&
    cd install-tl/ && \
    ./install-tl --persistent-downloads --profile texlive2015.profile && \
    rm install-tl.tar.gz && rm -r install-tl
RUN cp $(kpsewhich -var-value TEXMFSYSVAR)/fonts/conf/texlive-fontconfig.conf /etc/fonts/conf.d/09-texlive.conf
RUN fc-cache -fsv

RUN wget https://github.com/jgm/pandoc/releases/download/1.16.0.2/pandoc-1.16.0.2-1-amd64.deb && \
    dpkg -i pandoc* && \
    rm pandoc* && \
    apt-get clean

RUN mkdir /docs
WORKDIR /docs
VOLUME /docs


CMD /bin/bash
