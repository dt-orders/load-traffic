FROM alpine:3.9

# default and allow for overides to script arguments
ARG TEST_SCRIPT=load.jmx
ENV TEST_SCRIPT=$TEST_SCRIPT

ARG SERVER_URL=172.17.0.1
ENV SERVER_URL=$SERVER_URL

ARG SERVER_PORT=80
ENV SERVER_PORT=$SERVER_PORT

ARG NUM_LOOPS=1
ENV NUM_LOOPS=$NUM_LOOPS

ARG NUM_THREADS=1
ENV NUM_THREADS=$NUM_THREADS

ARG THINK_TIME=250
ENV THINK_TIME=$THINK_TIME

ARG JMETER_VERSION="5.2.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN ${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV PATH ${JMETER_BIN}:$PATH

RUN apk update \
	&& apk upgrade

RUN apk add --update openjdk8-jre tzdata curl unzip bash \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

COPY load.sh /
COPY load.jmx /

ENTRYPOINT /load.sh ${SERVER_URL} ${SERVER_PORT} ${NUM_LOOPS} ${NUM_THREADS} ${THINK_TIME} ${TEST_SCRIPT}
