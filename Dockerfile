FROM ubuntu
MAINTAINER onohr <bps@sculd.com>

ENV PKG="${PKG} wget tar unzip"
ENV PKG="${PKG} fontconfig fonts-takao-pgothic fonts-takao-gothic fonts-takao-mincho"
# ENV PKG="${PKG} python-pygments"
RUN apt-get -qq update && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && apt-get -qq --force-yes -y --no-install-recommends install language-pack-ja && dpkg-reconfigure -f noninteractive locales && if [ "${PKG}" ];then apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y --no-install-recommends upgrade && apt-get -o Acquire::http::Dl-Limit=300 --force-yes -y --no-install-recommends install ${PKG};fi && apt-get --force-yes -y --no-install-recommends install && apt-get autoremove && apt-get autoclean && apt-get clean && rm -rf "/var/cache/apt/archives/*" "/var/lib/apt/lists/*" && echo 'debconf debconf/frontend select Dialog' | debconf-set-selections
ENV TERM=xterm LANGUAGE=ja_JP:ja LANG=ja_JP.UTF-8 LC_TIME=POSIX
RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir -p install-tl && wget -nv -O install-tl.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && tar -xzf install-tl.tar.gz -C install-tl --strip-components=1
ADD texlive2015.profile install-tl/
RUN cd install-tl/ && ./install-tl --persistent-downloads --profile texlive2015.profile
RUN rm install-tl.tar.gz && rm -r install-tl
RUN cp $(kpsewhich -var-value TEXMFSYSVAR)/fonts/conf/texlive-fontconfig.conf /etc/fonts/conf.d/09-texlive.conf
RUN fc-cache -fsv

# # Install minted.sty:
# RUN cd /tmp;wget http://mirrors.ctan.org/macros/latex/contrib/minted.zip;unzip minted.zip;cd minted;make;mkdir -p /usr/share/texlive/texmf-dist/tex/latex/minted;cp minted.sty /usr/share/texlive/texmf-dist/tex/latex/minted/minted.sty; cd /tmp/;rm -rf /tmp/minted;mktexlsr
# # Install lineno.sty:
# RUN cd /tmp;wget http://mirrors.ctan.org/macros/latex/contrib/lineno.zip;unzip lineno.zip;cd lineno;mkdir -p /usr/share/texlive/texmf-dist/tex/latex/lineno;cp *.sty /usr/share/texlive/texmf-dist/tex/latex/lineno/;cd /tmp;rm -rf /tmp/lineno;mktexlsr
# # Install mdframed.sty:
# RUN cd /tmp;wget http://mirrors.ctan.org/macros/latex/contrib/mdframed.zip;unzip mdframed.zip;cd mdframed;make all;mkdir -p /usr/share/texlive/texmf-dist/tex/latex/mdframed;cp *.sty *.mdf *.cls /usr/share/texlive/texmf-dist/tex/latex/mdframed/; cd /tmp/;rm -rf /tmp/mdframed;mktexlsr
CMD /bin/bash
