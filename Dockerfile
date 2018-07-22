FROM ubuntu:18.04

MAINTAINER behdad.222 <behdad.222@gmail.com>

ENV SDK_TOOLS_VERSION "4333796"
ENV GRADLE_VERSION "gradle-4.4"
ENV GRADLE_PATH "9br9xq1tocpiv8o6njlyu5op1"

ENV ANDROID_HOME "/android-sdk-linux"
ENV PATH "$PATH:${ANDROID_HOME}/tools"

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y git
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y curl
RUN apt-get install -y jq
RUN apt-get install -y npm
RUN apt-get install -y gradle
RUN apt-get install -y zip

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip
RUN unzip ./android-sdk.zip -d ./android-sdk-linux
RUN rm ./android-sdk.zip

RUN wget --output-document=${GRADLE_VERSION}-all.zip https://services.gradle.org/distributions/${GRADLE_VERSION}-all.zip
RUN mkdir -p /root/.gradle/wrapper/dists/${GRADLE_VERSION}-all/${GRADLE_PATH} 
RUN unzip ./${GRADLE_VERSION}-all.zip -d /root/.gradle/wrapper/dists/${GRADLE_VERSION}-all/${GRADLE_PATH}
RUN chmod +x /root/.gradle/wrapper/dists/${GRADLE_VERSION}-all/9br9xq1tocpiv8o6njlyu5op1/${GRADLE_VERSION}/bin/gradle

RUN mkdir -p /root/.android
RUN touch /root/.android/repositories.cfg

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update

ADD packages.txt .
RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < ./packages.txt && \
    ${ANDROID_HOME}/tools/bin/sdkmanager ${PACKAGES}
    
RUN npm install -g cordova
