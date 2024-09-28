#!/usr/bin/env bash

set -Eeu pipefail

echo "[sharded-mongo/test.sh] forking mongos..."

mongos \
  --config /etc/mongos.conf \
  --fork \
  --logpath /var/log/mongos.log

echo "[sharded-mongo/test.sh] inserting documents and counting them..."

js=$(cat << JAVASCRIPT
db.testcollection.insertMany(
  [
    { shardkeyfield: 'foo' },
    { shardkeyfield: 'bar' },
    { shardkeyfield: 'baz' }
  ]
);
var result = db.testcollection.find({ shardkeyfield: { \$eq: 'bar' }}).toArray();
JSON.stringify(result)
JAVASCRIPT
)

mongocli="mongo"
if type mongosh &> /dev/null; then
  mongocli="mongosh"
fi

count=$($mongocli --quiet --eval "$js" localhost:27017/testdb | \
  jq 'map(select(.shardkeyfield == "bar")) | length')

if [[ $count != 1 ]]; then
  echo "[sharded-mongo/test.sh] expected 1 but got $count"
  exit 1
fi

echo ok
