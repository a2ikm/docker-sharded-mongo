ARG MONGO_VERSION=latest
FROM mongo:${MONGO_VERSION}

RUN mkdir -p \
      /var/lib/sharded-mongo/mongod-config \
      /var/lib/sharded-mongo/mongod-shard \
      /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["tail", "-f", "/var/log/mongos.log"]
