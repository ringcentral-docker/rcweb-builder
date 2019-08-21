ARG RUBY_PATH=/usr/local
ARG RUBY_VERSION=2.6.0
ARG NODE_VERSION=10.x
ARG CENTOS_VERSION=7
ARG GRADLE_VERSION=5.5.1
ARG GRADLE_HOME=/opt/gradle
ARG GRADLE_DOWNLOAD_SHA256=222a03fcf2fcaf3691767ce9549f78ebd4a77e73f9e23a396899fb70b420cd00
#======================================
# build Ruby
#======================================
FROM centos:7 AS rubybuild
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

FROM centos:7
LABEL maintainer="john.lin@ringcentral.com"
ARG RUBY_PATH
ARG NODE_VERSION
ARG GRADLE_HOME
ARG GRADLE_VERSION
ARG GRADLE_DOWNLOAD_SHA256
ENV PATH $GRADLE_HOME/bin:$RUBY_PATH/bin:$PATH
ENV DEV_MODE=true
ENV JAVA_HOME=/usr/lib/jvm/java
COPY --from=rubybuild $RUBY_PATH $RUBY_PATH

#======================================
# Install Dependent and Nodejs
#======================================
RUN curl --silent --location "https://rpm.nodesource.com/setup_${NODE_VERSION}" | bash - \
  && curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
  && yum makecache \
  && yum update -y \
  && yum install -y \
    nodejs wget pbzip2 unzip git ant rpm-build yarn java java-devel subversion sshpass\
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
# Install gradle
#======================================
RUN set -o errexit -o nounset \
	&& echo "Downloading Gradle" \
	&& wget --no-verbose --output-document=gradle.zip "https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle
  
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
    && gem --version \
    && gradle --version
