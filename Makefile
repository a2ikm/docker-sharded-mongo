MONGO_VERSION ?= 7.0

.PHONY: test
test:
	docker build ./src/$(MONGO_VERSION) \
		--tag a2ikm/sharded-mongo:$(MONGO_VERSION)-test
	docker run \
		--rm \
		--volume "$(CURDIR)/test/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d" \
		--volume "$(CURDIR)/test:/test" \
		a2ikm/sharded-mongo:$(MONGO_VERSION)-test bash /test/test.sh

.PHONY: test-all
test-all:
	make test MONGO_VERSION=4.0
	make test MONGO_VERSION=4.2
	make test MONGO_VERSION=4.4
	make test MONGO_VERSION=5.0
	make test MONGO_VERSION=6.0
	make test MONGO_VERSION=7.0
	make test MONGO_VERSION=8.0
