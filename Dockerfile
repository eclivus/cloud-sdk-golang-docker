FROM debian:wheezy
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i '1i deb     http://gce_debian_mirror.storage.googleapis.com/ wheezy         main' /etc/apt/sources.list
RUN apt-get update -y && apt-get install -y -qq --no-install-recommends wget unzip openssh-client curl build-essential ca-certificates git mercurial bzr && apt-get clean

#install go
RUN mkdir /goroot && curl https://storage.googleapis.com/golang/go1.5.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
RUN mkdir /gopath
ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

#install gc sdk
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options
RUN yes | google-cloud-sdk/bin/gcloud components update pkg-go
RUN mkdir -p /root/.ssh
ENV PATH /google-cloud-sdk/bin:$PATH
VOLUME ["/.config"]
CMD bash

# install go appengine sdk
RUN wget https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.32.zip && \
    unzip go_appengine_sdk_linux_amd64-1.9.32.zip
ENV PATH $PATH:/go_appengine
