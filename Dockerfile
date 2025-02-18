FROM debian:stretch-slim
ARG JAVA_VERSION="20.2.0.r11-grl"
ARG GROOVY_VERSION="3.0.5"

ARG USER_UID="1000"
ARG USER_GID="1000"
ARG USER_NAME="user"

RUN groupadd -g $USER_GID $USER_NAME && \
   useradd -m -g $USER_GID -u $USER_UID $USER_NAME && \
   apt-get update && \
   apt-get install -y zip unzip curl build-essential libz-dev zlib1g-dev && \
   rm -rf /var/lib/apt/lists/* && \
   rm -rf /tmp/*

USER $USER_UID:$USER_GID

RUN curl -s "https://get.sdkman.io" | bash

RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install groovy $GROOVY_VERSION && \
    sdk flush temp && \
    sdk flush archives"

ENV GROOVY_HOME="/home/$USER_NAME/.sdkman/candidates/groovy/current"
ENV JAVA_HOME="/home/$USER_NAME/.sdkman/candidates/java/current"
ENV PATH="$GROOVY_HOME/bin:$JAVA_HOME/bin:$PATH"

RUN gu install native-image