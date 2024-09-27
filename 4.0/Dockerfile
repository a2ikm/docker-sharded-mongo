FROM mongo:4.0

RUN set -eux; \
      dpkgArch="$(dpkg --print-architecture)"; \
      case "${dpkgArch##*-}" in \
            amd64) mongoshArch='linux-x64' ;; \
            arm64) mongoshArch='linux-arm64' ;; \
            *) echo >&2; echo >&2 "error: current architecture ($dpkgArch) is not supported"; echo >&2; exit 1 ;; \
      esac; \
      \
      apt-get update && \
      apt-get install -y wget && \
      wget https://downloads.mongodb.com/compass/mongosh-1.6.0-${mongoshArch}.tgz && \
      tar zxf mongosh-1.6.0-${mongoshArch}.tgz && \
      chmod +x mongosh-1.6.0-${mongoshArch}/bin/mongosh && \
      mv mongosh-1.6.0-${mongoshArch}/bin/mongosh /usr/local/bin && \
      mv mongosh-1.6.0-${mongoshArch}/bin/mongosh_crypt_v1.so /usr/local/lib && \
      rm -rf mongosh-1.6.0-${mongoshArch}.tgz mongosh-1.6.0-${mongoshArch} && \
      rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
      /var/lib/sharded-mongo/mongod-config \
      /var/lib/sharded-mongo/mongod-shard \
      /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mongos", "-f", "/etc/mongos.conf"]
