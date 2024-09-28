FROM mongo:4.2

RUN mkdir -p \
      /var/lib/sharded-mongo/mongod-config \
      /var/lib/sharded-mongo/mongod-shard \
      /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mongos", "-f", "/etc/mongos.conf"]
