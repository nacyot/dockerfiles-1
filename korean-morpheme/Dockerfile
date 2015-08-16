FROM ubuntu:14.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl git wget && \
  apt-get install -y automake && \
  rm -rf /var/lib/apt/lists/*

# Install mecab-ko
RUN \
  cd /opt &&\
  wget https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz &&\
  tar xvf mecab-0.996-ko-0.9.2.tar.gz &&\
  cd /opt/mecab-0.996-ko-0.9.2 &&\
  ./configure &&\
  make &&\
  make check &&\
  make install &&\
  ldconfig

RUN \
  cd /opt &&\
  wget https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.1-20150707.tar.gz &&\
  tar xvf mecab-ko-dic-2.0.1-20150707.tar.gz &&\
  cd /opt/mecab-ko-dic-2.0.1-20150707 &&\
  ./autogen.sh &&\
  ./configure &&\
  make &&\
  make install

# Install user dic
COPY cache-buster cache-buster
ADD https://raw.githubusercontent.com/n42corp/search-ko-dic/master/servicecustom.csv /opt/mecab-ko-dic-2.0.1-20150707/user-dic/servicecustom.csv
RUN cd /opt/mecab-ko-dic-2.0.1-20150707 &&\
  tools/add-userdic.sh &&\
  make install

CMD mecab
