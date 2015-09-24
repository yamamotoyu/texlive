FROM ubuntu
MAINTAINER onohr <bps@sculd.com>

ENV PKG="${PKG} texlive"
ENV PKG="${PKG} texlive-lang-cjk"
ENV PKG="${PKG} texlive-fonts-recommended"
ENV PKG="${PKG} texlive-fonts-extra"
ENV PKG="${PKG} texlive-xetex"
ENV PKG="${PKG} texlive-luatex"
ENV PKG="${PKG} texlive-latex-extra"
ENV PKG="${PKG} fontconfig fonts-takao-pgothic fonts-takao-gothic fonts-takao-mincho"
ENV PKG="${PKG} python-pygments"
ENV PKG="${PKG} unzip wget"
RUN apt-get -qq update && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && apt-get -qq --force-yes -y --no-install-recommends install language-pack-ja && dpkg-reconfigure -f noninteractive locales && if [ "${PPA}" ];then apt-get -qq --force-yes -y --no-install-recommends install software-properties-common python-software-properties && bash -c "for ppa in ${PPA}; do add-apt-repository -y \${ppa};done;apt-get -qq update";fi && if [ "${PKG}" ];then apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y --no-install-recommends install ${PKG};fi && apt-get --force-yes -y --no-install-recommends install && apt-get autoremove && apt-get autoclean && apt-get clean && rm -rf "/var/cache/apt/archives/*" "/var/lib/apt/lists/*" && echo 'debconf debconf/frontend select Dialog' | debconf-set-selections && fc-cache -fsv
ENV TERM=xterm LANGUAGE=ja_JP:ja LANG=ja_JP.UTF-8 LC_TIME=POSIX
RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install minted.sty:
RUN cd /tmp;wget http://mirrors.ctan.org/macros/latex/contrib/minted.zip;unzip minted.zip;cd minted;make;mkdir -p /usr/share/texlive/texmf-dist/tex/latex/minted;cp minted.sty /usr/share/texlive/texmf-dist/tex/latex/minted/minted.sty; cd /tmp/;rm -rf /tmp/minted;mktexlsr
# Install lineno.sty:
RUN cd /tmp;wget http://mirrors.ctan.org/macros/latex/contrib/lineno.zip;unzip lineno.zip;cd lineno;mkdir -p /usr/share/texlive/texmf-dist/tex/latex/lineno;cp *.sty /usr/share/texlive/texmf-dist/tex/latex/lineno/;cd /tmp;rm -rf /tmp/lineno;mktexlsr
# Install mdframed.sty:
RUN cd /tmp;wget http://mirrors.ctan.org/macros/latex/contrib/mdframed.zip;unzip mdframed.zip;cd mdframed;make all;mkdir -p /usr/share/texlive/texmf-dist/tex/latex/mdframed;cp *.sty *.mdf *.cls /usr/share/texlive/texmf-dist/tex/latex/mdframed/; cd /tmp/;rm -rf /tmp/mdframed;mktexlsr
CMD /bin/bash
