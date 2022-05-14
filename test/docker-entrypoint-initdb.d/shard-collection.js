sh.enableSharding("testdb")
sh.shardCollection("testdb.testcollection", { shardkeyfield: "hashed" })
