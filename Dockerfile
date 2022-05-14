ARG MONGO_VERSION=latest
FROM mongo:${MONGO_VERSION}

RUN set -eux; \
      apt-get update; \
      apt-get install -y --no-install-recommends \
        curl \
        netcat \
      ; \
      rm -rf /var/lib/apt/lists/*

RUN curl -sLo /usr/local/bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for; \
      chmod +x /usr/local/bin/wait-for

RUN mkdir -p \
      /var/lib/sharded-mongo/mongod-config \
      /var/lib/sharded-mongo/mongod-shard \
      /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["tail", "-f", "/var/log/mongos.log"]
