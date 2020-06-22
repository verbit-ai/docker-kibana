#!bin/bash

CONF="/opt/kibana-$KIBANA_VERSION-linux-x86_64/config/kibana.yml"

sed -ri "s|elasticsearch.url:[^\r\n]*|elasticsearch.url: $ELASTICSEARCH_PROTOCOL://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT|" "$CONF"
sed -i "s;.*server\.host:.*;server\.host: ${KIBANA_HOST};" "$CONF"

sed -ri "s|elasticsearch.password:[^\r\n]*|elasticsearch.password: $KIBANA_PWD|" "$CONF"
sed -ri "s|elasticsearch.requestTimeout:[^\r\n]*|elasticsearch.requestTimeout: $ELASTICSEARCH_REQUEST_TIMEOUT|" "$CONF"
sed -ri "s|elasticsearch.shardTimeout:[^\r\n]*|elasticsearch.shardTimeout: $ELASTICSEARCH_SHARD_TIMEOUT|" "$CONF"
sed -ri "s|elasticsearch.ssl.verify:[^\r\n]*|elasticsearch.ssl.verify: true|" "$CONF"
sed -ri "s|elasticsearch.ssl.ca:[^\r\n]*|elasticsearch.ssl.ca: /etc/elasticsearch/searchguard/ssl/ca/root-ca.pem|" "$CONF"
# BASE PATH
if [ ! -z $SERVER_BASE_PATH ]; then
    sed -ri "s|#server.basePath:[^\r\n]*|server.basePath: $SERVER_BASE_PATH|" "$CONF"
fi
