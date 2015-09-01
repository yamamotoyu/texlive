FROM ubuntu
MAINTAINER onohr <bps@sculd.com>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm LANGUAGE=ja_JP:ja LANG=ja_JP.UTF-8 LC_TIME=POSIX
RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get -qq --force-yes -y --no-install-recommends install language-pack-ja && dpkg-reconfigure -f noninteractive locales && \
    apt-get -qq update && apt-get --force-yes -y upgrade && \
    apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive && \
    apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-lang-cjk && \
    apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-fonts-recommended && \
    apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-fonts-extra && \
    apt-get --force-yes -y install python-pygments && \
    apt-get --force-yes -y update --fix-missing && \
    apt-get autoremove && apt-get autoclean && apt-get clean && rm -rf "/var/cache/apt/archives/*" "/var/lib/apt/lists/*" && \
    echo 'debconf debconf/frontend select Dialog' | debconf-set-selections
ENV DEBIAN_FRONTEND dialog
CMD /bin/bash
