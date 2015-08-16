FROM ubuntu:14.04

RUN locale-gen ko_KR.UTF-8
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

##### Install Ruby
RUN apt-get update

# Install ruby dependencies
RUN apt-get install -y wget curl \
    build-essential git git-core \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev

RUN apt-get update

# Install ruby-install
RUN cd /tmp &&\
  wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz &&\
  tar -xzvf ruby-install-0.4.3.tar.gz &&\
  cd ruby-install-0.4.3/ &&\
  make install

# Install MRI Ruby 2.2.2
RUN ruby-install ruby 2.2.2

# Add Ruby binaries to $PATH
ENV PATH /opt/rubies/ruby-2.2.2/bin:$PATH

# Add options to gemrc
RUN echo "gem: --no-document" > ~/.gemrc

# Install bundler
RUN gem install bundler
##### End Install Ruby


RUN gem install sinatra --no-document
RUN gem install sinatra-contrib --no-document
RUN gem install natto --no-document
RUN gem install multi_json --no-document
RUN gem install oj --no-document


##### Install Mecab-ko
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
##### END Install Mecab-ko


RUN mkdir /app
WORKDIR /app
COPY sinatra /app/

CMD ruby server.rb

EXPOSE 4567
