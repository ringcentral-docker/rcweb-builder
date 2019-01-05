ARG RUBY_PATH=/usr/local
ARG RUBY_VERSION=2.6.0
ARG NODE_VERSION=8.x

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
# RUN yum makecache \
#   && yum update -y \
#   && yum install -y \
#     which patch readline readline-devel zlib zlib-devel \
#     libyaml-devel libffi-devel openssl-devel bzip2 autoconf \
#     automake libtool bison iconv-devel sqlite-devel \
#   && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
#   && curl -sSL https://get.rvm.io | bash -s stable \
#   && npm cache verify \
#   && yum clean all

# RUN /bin/bash -l -c "rvm requirements"
#RUN /bin/bash -l -c "rvm install ${RUBY_VERSION}"
#RUN /bin/bash -l -c "rvm use ${RUBY_VERSION} --default"
RUN gem install bundler
RUN gem install compass

#======================================
# Show Version
#======================================
RUN node --version
RUN npm version
RUN yarn --version
RUN compass version
RUN grunt --version
RUN ruby --version
RUN bundle --version
RUN gem --version