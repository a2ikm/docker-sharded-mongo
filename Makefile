MONGO_VERSION ?= latest

.PHONY: test
test:
	docker build ./src \
		--build-arg MONGO_VERSION=$(MONGO_VERSION) \
		--tag a2ikm/sharded-mongo:$(MONGO_VERSION)-test
	docker run \
		--rm \
		--volume "$(CURDIR)/test/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d" \
		--volume "$(CURDIR)/test:/test" \
		a2ikm/sharded-mongo:$(MONGO_VERSION)-test bash /test/test.sh
