FROM ubuntu:latest

ENV KIBANA_VERSION 6.8.1
ENV SG_VERSION 6.8.1-18.4
ENV NODE_VERSION v10.15.2
ENV NODE_PLATFORM=linux-x64
ENV DEBIAN_FRONTEND=noninteractive

ENV PATH /opt/kibana-${KIBANA_VERSION}-linux-x86_64/bin:/usr/local/lib/nodejs/node-${NODE_VERSION}-${NODE_PLATFORM}/bin:$PATH

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#g' /etc/apt/sources.list && \
    apt-get -qy update; apt-get install -qy bash curl wget && \
    mkdir -p /opt /usr/local/lib/nodejs && \
    curl -s https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${NODE_PLATFORM}.tar.gz | tar zx -C /usr/local/lib/nodejs

RUN curl -s https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar zx -C /opt && \
		/opt/kibana-${KIBANA_VERSION}-linux-x86_64/bin/kibana-plugin install "https://oss.sonatype.org/content/repositories/releases/com/floragunn/search-guard-kibana-plugin/$SG_VERSION/search-guard-kibana-plugin-$SG_VERSION.zip"


RUN mkdir -p /.backup/kibana
COPY config /.backup/kibana/config

ADD ./src/ /run/
RUN chmod +x -R /run/
ADD root.pem /
ENV KIBANA_PWD="changeme" \ 
    ELASTICSEARCH_HOST="0-0-0-0" \ 
    ELASTICSEARCH_PORT="9200" \ 
    KIBANA_HOST="0.0.0.0" \
    ELASTICSEARCH_PROTOCOL="https"
		
EXPOSE 5601

# See https://github.com/elastic/kibana/issues/6057
COPY config/kibana.yml /opt/kibana-$KIBANA_VERSION-linux-x86_64/config/kibana.yml
RUN /opt/kibana-${KIBANA_VERSION}-linux-x86_64/bin/kibana 2>&1 | grep -m 1 "Optimization of .* complete in .* seconds"
RUN rm -f /opt/kibana-$KIBANA_VERSION-linux-x86_64/config/kibana.yml

ENTRYPOINT ["/run/entrypoint.sh"]
CMD ["kibana"]
