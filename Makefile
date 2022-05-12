VERSIONS = 4.0 4.2 4.4 5.0

build-all: $(VERSIONS)

$(VERSIONS):
	docker build --build-arg VERSION=$@ --tag a2ikm/sharded-mongo:$@ .

push-all:
	docker push --all-tags a2ikm/sharded-mongo
