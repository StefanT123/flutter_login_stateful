FROM ubuntu:latest

ENV ANDROID_HOME="/opt/android-sdk" \
    PATH="/opt/android-sdk/tools/bin:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:$PATH"

RUN groupadd -g 1000 flutter && \
    useradd -u 1000 -g flutter -m flutter -G sudo

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk bash curl git unzip xz-utils libglu1-mesa

RUN git clone -b master https://github.com/flutter/flutter.git /opt/flutter

RUN curl -s -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && mkdir /opt/android-sdk \
    && unzip sdk-tools-linux-4333796.zip -d /opt/android-sdk > /dev/null \
    && rm sdk-tools-linux-4333796.zip

RUN mkdir ~/.android \
    && echo 'count=0' > ~/.android/repositories.cfg \
    && yes | sdkmanager --licenses > /dev/null \
    && sdkmanager "tools" "build-tools;29.0.0" "platforms;android-29" "platform-tools" > /dev/null \
    && sdkmanager "system-images;android-27;google_apis_playstore;x86" \
    && yes | sdkmanager --licenses > /dev/null \
    && flutter doctor -v \
    && chown -R flutter:flutter /opt

WORKDIR /flutter_app

RUN chown -R flutter:flutter /flutter_app

USER flutter

CMD ["bash"]
