FROM ubuntu:18.04

MAINTAINER behdad.222 <behdad.222@gmail.com>

ENV SDK_TOOLS_VERSION "4333796"

ENV ANDROID_HOME "/android-sdk-linux"
ENV PATH "$PATH:${ANDROID_HOME}/tools"

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y git
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y wget
RUN apt-get install unzip
RUN apt-get install curl
RUN apt-get install jq

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip
RUN unzip ./android-sdk.zip -d ./android-sdk-linux
RUN rm ./android-sdk.zip

RUN mkdir -p /root/.android
RUN touch /root/.android/repositories.cfg

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update

ADD packages.txt .
RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < ./packages.txt && \
    ${ANDROID_HOME}/tools/bin/sdkmanager ${PACKAGES}
    
