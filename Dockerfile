FROM rayba82/debian:latest

MAINTAINER RayBa "rainerbaun@gmail.com"

ARG JAVA_URL=http://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.tar.gz
ENV JAVA_HOME /opt/java
ARG HEALTH_DIR=/opt/health
RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    wget git	

RUN cd $HOME \
    && wget -O jdk.tar.gz -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_URL \
    && mkdir -p $JAVA_HOME \
    && tar -xzf jdk.tar.gz -C $JAVA_HOME --strip-components 1 \
    && rm jdk.tar.gz \
    && update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 100

RUN git clone https://RayBa82@bitbucket.org/RayBa82/java-healthcheck.git health \
    && cd health \
    && sh gradlew build \
    && mkdir /opt/health \
    && cp build/libs/health.jar $HEALTH_DIR/ \
    && chmod a+x $HEALTH_DIR/health.jar \
    && cd .. \
    && rm -rf health \
    && rm -r /root/.gradle


RUN apt-get remove -y git wget --autoremove --purge
