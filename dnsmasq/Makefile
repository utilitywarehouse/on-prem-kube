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
run:
	docker run --net=host --rm --cap-add=NET_ADMIN $(NAME):$(VERSION) -d -q 
setup-network:
	./bin/setup-network
