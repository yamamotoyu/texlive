FROM ubuntu
MAINTAINER onohr <bps@sculd.com>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm LANGUAGE=ja_JP:ja LANG=ja_JP.UTF-8 LC_TIME=POSIX
RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apt-get -qq update && apt-get --force-yes -y upgrade
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-lang-cjk
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-fonts-recommended
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-fonts-extra
RUN apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y install texlive-xetex
RUN apt-get --force-yes -y install python-pygments
RUN apt-get --force-yes -y update --fix-missing
# New minted.sty from here:
RUN cd /tmp;wget http://mirrors.ctan.org/macros/latex/contrib/minted.zip;unzip minted.zip;cd minted;make;mkdir -p /usr/share/texmf-texlive/tex/latex/minted;cp minted.sty /usr/share/texmf-texlive/tex/latex/minted/minted.sty; rm -rf /tmp/minted;mktexlsr
ENV DEBIAN_FRONTEND dialog
CMD /bin/bash
