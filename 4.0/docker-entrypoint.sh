#!/usr/bin/env bash
#
# This script coodinates a MongoDB sharded cluster.
# The implementation follows https://www.mongodb.com/docs/manual/tutorial/deploy-shard-cluster/.
#

set -Eeuo pipefail

echo "[sharded-mongo/docker-entrypoint.sh] forking config server..."

mongod \
  --configsvr \
  --replSet config \
  --dbpath /var/lib/sharded-mongo/mongod-config \
  --bind_ip ::,0.0.0.0 \
  --port 27019 \
  --fork \
  --logpath /var/log/mongod-config.log

if [ ! -e /var/lib/sharded-mongo/mongod-config.initialized ]; then
  echo "[sharded-mongo/docker-entrypoint.sh] initializing config server..."
  mongo --eval 'rs.initiate({_id: "config", configsvr: true, members: [{ _id : 0, host : "localhost:27019" }]})' localhost:27019
  touch /var/lib/sharded-mongo/mongod-config.initialized
fi

echo "[sharded-mongo/docker-entrypoint.sh] forking shard server..."

mongod \
  --shardsvr \
  --replSet shard \
  --dbpath /var/lib/sharded-mongo/mongod-shard \
  --bind_ip ::,0.0.0.0 \
  --port 27018 \
  --fork \
  --logpath /var/log/mongod-shard.log

if [ ! -e /var/lib/sharded-mongo/mongod-shard.initialized ]; then
  echo "[sharded-mongo/docker-entrypoint.sh] initializing shard server..."
  mongo --eval 'rs.initiate({_id: "shard", members: [{ _id : 0, host : "localhost:27018" }]})' localhost:27018
  touch /var/lib/sharded-mongo/mongod-shard.initialized
fi

echo "[sharded-mongo/docker-entrypoint.sh] forking mongos server..."

cat <<CONF >/etc/mongos.conf
net:
  bindIpAll: true
  ipv6: true
  port: 27017
sharding:
  configDB: config/localhost:27019
CONF

mongos \
  --config /etc/mongos.conf \
  --fork \
  --logpath /var/log/mongos.log

if [ ! -e /var/lib/sharded-mongo/mongos.initialized ]; then
  echo "[sharded-mongo/docker-entrypoint.sh] initializing mongos server..."
  mongo --eval 'sh.addShard("shard/localhost:27018")' localhost:27017
  touch /var/lib/sharded-mongo/mongos.initialized

  for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
      *.sh) echo "$0: running $f"; . "$f" ;;
      *.js) echo "$0: running $f"; mongo localhost:27017 "$f"; echo ;;
      *)    echo "$0: ignoring $f" ;;
    esac
  done
fi

echo "[sharded-mongo/docker-entrypoint.sh] shutting mongos server down..."

mongo --eval 'db.shutdownServer()' localhost:27017/admin

while pgrep mongos > /dev/null; do
  echo "[sharded-mongo/docker-entrypoint.sh] mongos is shutting down. sleep 1 second..."
  sleep 1
done

exec "$@"
