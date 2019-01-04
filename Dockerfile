FROM centos:centos7
LABEL maintainer="john.lin@ringcentral.com"

ENV DEV_MODE=true
ENV NODE_VERSION=8.x
ENV RUBY_VERSION=2.6

#======================================
# Install Dependent and Nodejs
#======================================
RUN curl --silent --location "https://rpm.nodesource.com/setup_${NODE_VERSION}" | bash - \
  && yum makecache \
  && yum update -y \
  && yum install -y \
    nodejs gcc-c++ make wget unzip git ant rpm-build \
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
  && yum -y update \
  && yum install -y \
    which patch readline readline-devel zlib zlib-devel \
    libyaml-devel libffi-devel openssl-devel bzip2 autoconf \
    automake libtool bison iconv-devel sqlite-devel \
  && curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
  && curl -L get.rvm.io | bash -s stable \
  && npm cache verify \
  && yum clean all

RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ${RUBY_VERSION}"
RUN /bin/bash -l -c "rvm use ${RUBY_VERSION} --default"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "gem install compass"

#======================================
# Install Version
#======================================
RUN node --version \
    && npm version \
    && yarn --version \
    && compass version \
    && grunt version