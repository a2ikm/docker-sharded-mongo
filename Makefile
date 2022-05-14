MONGO_VERSIONS = 4.0 4.2 4.4 5.0

build-all: $(MONGO_VERSIONS)

$(MONGO_VERSIONS):
	docker build --build-arg MONGO_VERSION=$@ --tag a2ikm/sharded-mongo:$@ .

push-all:
	docker push --all-tags a2ikm/sharded-mongo
