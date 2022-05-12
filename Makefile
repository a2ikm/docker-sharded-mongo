.PHONY: build
build-4-2:
	docker build --build-arg VERSION=4.2 --tag a2ikm/sharded-mongo:4.2 .
