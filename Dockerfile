FROM centos:centos7
LABEL maintainer="john.lin@ringcentral.com"

ENV DEV_MODE=true
ENV NODE_VERSION=8.x

#======================================
# Install Dependent and Nodejs
#======================================
RUN curl --silent --location "https://rpm.nodesource.com/setup_${NODE_VERSION}" | bash - \
  && yum -y install nodejs gcc-c++ make wget unzip git ant ruby-devel rubygems rpm-build \
  && gem install compass \
  && npm config set electron_mirror https://npm.taobao.org/mirrors/electron  \
  && npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass  \
  && npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs  \
  && npm config set registry https://registry.npm.taobao.org  \
  && npm install -g grunt-cli \
  && npm cache verify \
  && yum clean all \
  && rm -rf /var/cache/yum

RUN node --version \
    && npm version \
    && compass version \
    && grunt version