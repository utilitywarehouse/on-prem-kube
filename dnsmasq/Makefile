NAME = angelx/dnsmasq
VERSION = 0.0.1

all: build

build:
	docker build -t $(NAME):$(VERSION) .

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME):$(VERSION)

push_latest:
	docker push $(NAME):latest

last_built_date:
	docker inspect -f '{{ .Created }}' $(NAME):$(VERSION)

setup-network:
	./bin/setup-network

run: setup-network build
	docker-compose up
