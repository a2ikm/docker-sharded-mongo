.PHONY: build-4-2
build-4-2:
	docker build --build-arg VERSION=4.2 --tag a2ikm/sharded-mongo:4.2 .

.PHONY: push-all
push-all:
	docker push --all-tags a2ikm/sharded-mongo
