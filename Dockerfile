FROM centos:centos7
LABEL maintainer="john.lin@ringcentral.com"

ENV DEV_MODE=true
ENV NODE_VERSION=8.x
ENV RUBY_VERSION=2.6

#======================================
# Install Dependent and Nodejs
#======================================
RUN curl --silent --location "https://rpm.nodesource.com/setup_${NODE_VERSION}" | bash - \
  && curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
  && yum makecache \
  && yum update -y \
  && yum install -y \
    nodejs gcc-c++ make wget unzip git ant rpm-build yarn \
  && npm config set electron_mirror https://npm.taobao.org/mirrors/electron  \
  && npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass  \
  && npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs  \
  && npm config set registry https://registry.npm.taobao.org  \
  && npm install -g grunt-cli \
  && npm cache verify \
  && yum clean all

#======================================
# Install Dependent Ruby
#======================================
RUN yum makecache \
  && yum update -y \
  && yum install -y \
    which patch readline readline-devel zlib zlib-devel \
    libyaml-devel libffi-devel openssl-devel bzip2 autoconf \
    automake libtool bison iconv-devel sqlite-devel \
  && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
  && curl -sSL https://get.rvm.io | bash -s stable \
  && npm cache verify \
  && yum clean all

RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ${RUBY_VERSION}"
RUN /bin/bash -l -c "rvm use ${RUBY_VERSION} --default"
RUN /bin/bash -l -c "gem install bundler"
RUN /bin/bash -l -c "gem install compass"

#======================================
# Show Version
#======================================
RUN node --version \
    && npm version \
    && yarn --version \
#    && compass version \
    && grunt version \
    && ruby --version \
    && rvm --version \
    && bundle --version \
    && gem --version