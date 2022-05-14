#!/usr/bin/env bash

set -Eeu pipefail

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

count=$(mongo --quiet --eval "$js" localhost:27017/testdb | \
  jq 'map(select(.shardkeyfield == "bar")) | length')

if [[ $count != 1 ]]; then
  echo "expected 1 but got $count"
  exit 1
fi

