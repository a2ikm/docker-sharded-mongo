#!/usr/bin/env bash

set -Eeuo pipefail

mongod \
  --configsvr \
  --replSet config \
  --dbpath /var/lib/sharded-mongo/mongod-config \
  --bind_ip ::,0.0.0.0 \
  --port 27019 \
  --fork \
  --logpath /var/log/mongod-config.log

wait-for localhost:27019

if [ ! -e /var/lib/sharded-mongo/mongod-config.initialized ]; then
  mongosh --eval 'rs.initiate({_id: "config", configsvr: true, members: [{ _id : 0, host : "localhost:27019" }]})' localhost:27019
  touch /var/lib/sharded-mongo/mongod-config.initialized
fi

mongod \
  --shardsvr \
  --replSet shard \
  --dbpath /var/lib/sharded-mongo/mongod-shard \
  --bind_ip ::,0.0.0.0 \
  --port 27018 \
  --fork \
  --logpath /var/log/mongod-shard.log

wait-for localhost:27018

if [ ! -e /var/lib/sharded-mongo/mongod-shard.initialized ]; then
  mongosh --eval 'rs.initiate({_id: "shard", members: [{ _id : 0, host : "localhost:27018" }]})' localhost:27018
  touch /var/lib/sharded-mongo/mongod-shard.initialized
fi

mongos \
  --configdb config/localhost:27019 \
  --bind_ip ::,0.0.0.0 \
  --port 27017 \
  --fork \
  --logpath /var/log/mongos.log

wait-for localhost:27017

if [ ! -e /var/lib/sharded-mongo/mongos.initialized ]; then
  mongosh --eval 'sh.addShard("shard/localhost:27018")' localhost:27017
  touch /var/lib/sharded-mongo/mongos.initialized

  for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
      *.sh) echo "$0: running $f"; . "$f" ;;
      *.js) echo "$0: running $f"; mongosh localhost:27017 "$f"; echo ;;
      *)    echo "$0: ignoring $f" ;;
    esac
  done
fi

exec "$@"
