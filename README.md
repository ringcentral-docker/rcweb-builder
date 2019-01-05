# RCWeb Builder Image

## Build Status

[![Build Status](https://travis-ci.org/ringcentral-docker/rcweb-builder.svg?branch=master)](https://travis-ci.org/ringcentral-docker/rcweb-builder)

## Image description

* Base on the latest version of CentOS Docker Image : [link](https://hub.docker.com/_/centos/)

```bash
$ /bin/bash -l -c "node --version"
v10.15.0

$ /bin/bash -l -c "npm version"
{ npm: '6.4.1',
  ares: '1.15.0',
  cldr: '33.1',
  http_parser: '2.8.0',
  icu: '62.1',
  modules: '64',
  napi: '3',
  nghttp2: '1.34.0',
  node: '10.15.0',
  openssl: '1.1.0j',
  tz: '2018e',
  unicode: '11.0',
  uv: '1.23.2',
  v8: '6.8.275.32-node.45',
  zlib: '1.2.11' }

$ /bin/bash -l -c "yarn --version"
1.12.3

$ /bin/bash -l -c "compass version"
Compass 1.0.3 (Polaris)
Copyright (c) 2008-2019 Chris Eppstein
Released under the MIT License.
Compass is charityware.
Please make a tax deductable donation for a worthy cause: http://umdf.org/compass

$ /bin/bash -l -c "grunt --version"
grunt-cli v1.3.2

$ /bin/bash -l -c "ruby --version"
ruby 2.6.0p0 (2018-12-25 revision 66547) [x86_64-linux]

$ /bin/bash -l -c "rvm --version"
rvm 1.29.7 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io]

$ /bin/bash -l -c "bundle --version"
Bundler version 2.0.1

$ /bin/bash -l -c "gem --version"
3.0.1
```

## How to use this image

## Get the Image

```bash
docker pull ringcentral/rcweb-builder:latest
```

for more detail information please refer this url:
<https://github.com/ringcentral-docker/rcweb-builder>