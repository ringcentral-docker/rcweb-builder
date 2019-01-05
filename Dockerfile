ARG RUBY_PATH=/usr/local
ARG RUBY_VERSION=2.6.0
ARG NODE_VERSION=10.x

#======================================
# build Ruby
#======================================
FROM centos:centos7 AS rubybuild
ARG RUBY_PATH
ARG RUBY_VERSION
RUN yum makecache \
  && yum update -y \
  && yum install -y \
    git bzip2 openssl-devel readline-devel zlib-devel \
  && yum groupinstall "Development Tools" -y \
  && yum clean all
RUN git clone https://github.com/rbenv/ruby-build.git $RUBY_PATH/plugins/ruby-build \
&&  $RUBY_PATH/plugins/ruby-build/install.sh
RUN ruby-build $RUBY_VERSION $RUBY_PATH

FROM centos:centos7
LABEL maintainer="john.lin@ringcentral.com"
ARG RUBY_PATH
ARG NODE_VERSION
ENV PATH $RUBY_PATH/bin:$PATH
ENV DEV_MODE=true
COPY --from=rubybuild $RUBY_PATH $RUBY_PATH

#======================================
# Install Dependent and Nodejs
#======================================
RUN curl --silent --location "https://rpm.nodesource.com/setup_${NODE_VERSION}" | bash - \
  && curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
  && yum makecache \
  && yum update -y \
  && yum install -y \
    nodejs wget pbzip2 unzip git ant rpm-build yarn \
  && yum groupinstall "Development Tools" -y \
  && yum install openssl-devel readline-devel zlib-devel -y \
  && alias tar='tar --use-compress-program=pbzip2' \
  && npm install -g grunt-cli \
  && npm cache verify \
  && yum clean all

#======================================
# Install bundler & compass
#======================================
RUN gem install bundler \
  && gem install compass

#======================================
# Set npm mirror
#======================================
RUN npm config set electron_mirror https://npm.taobao.org/mirrors/electron  \
  && npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass  \
  && npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs  \
  && npm config set registry https://registry.npm.taobao.org

#======================================
# Show Version
#======================================
RUN node --version \
    && npm version \
    && yarn --version \
    && compass version \
    && grunt --version \
    && ruby --version \
    && bundle --version \
    && gem --version