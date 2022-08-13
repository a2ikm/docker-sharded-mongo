# a2ikm/sharded-mongo

https://hub.docker.com/r/a2ikm/sharded-mongo

## What is this?

`a2ikm/sharded-mongo` is a container which runs a smallest sharded MongoDB cluster.
It is composed of one shard server, one config server, and one mongos process.

**WARNING: this project focuses on simple CI usages and is insecure. Don't use it for production.**

## How to use

```
$ docker run --rm --publish 27017:27017 a2ikm/sharded-mongo
```

The mongos process listens the `27017` port for client connections.

It loads  `*.sh` files or `*.js` files mounted at `/docker-entrypoint-initdb.d`.

## Supported MongoDB versions

They are managed in versions.json hosted on GitHub:
https://github.com/a2ikm/docker-sharded-mongo/blob/main/versions.json.

It is updated weekly to track recent minor versions.

## Development

Its Dockerfile and entrypoint script are managed on GitHub:
https://github.com/a2ikm/docker-sharded-mongo

### Issue management

If you have an issue, please file it to https://github.com/a2ikm/docker-sharded-mongo/issues.

### Release management

1. Create a pull request to the `main` branch
2. Pass the CI, and merge it
3. Then, new images are built and pushed to Docker Hub

### How to test on your local machine

```
# with latest version
$ make test

# with specific version
$ make test MONGO_VERSION=4.4
```
