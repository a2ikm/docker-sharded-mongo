sh.enableSharding("test")
sh.shardCollection("test.test0", { somefield: "hashed" })
