FROM ubuntu
MAINTAINER onohr <hiroyuki.ono.jc@renesas.com>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm LANGUAGE=ja_JP:ja LANG=ja_JP.UTF-8 LC_TIME=POSIX
RUN echo 'Acquire::HTTP::Proxy "http://cpusys.mu.renesas.com:3142";' > /etc/apt/apt.conf.d/01proxy && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apt-get -qq update && apt-get --force-yes -y upgrade
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-lang-cjk
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-fonts-recommended
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-fonts-extra
RUN apt-get --force-yes -y install python-pygments
RUN apt-get --force-yes -y update --fix-missing

ENV DEBIAN_FRONTEND dialog
CMD /bin/bash
