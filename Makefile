NS ?= arnaudrebts
VERSION ?= latest

IMAGE_NAME ?= ib-tws
CONTAINER_NAME ?= ib-tws
CONTAINER_INSTANCE ?= default

.PHONY: build

build: Dockerfile
	docker build -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .

run:
	docker run --rm -it \
		--name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) \
		-p 4000:4000 -p 4001:4001 -p 5900:5900 \
		--tmpfs /var:rw,exec \
		-e IB_USERNAME \
		-e IB_PASSWORD \
		-e VNC_PASSWORD \
		$(NS)/$(IMAGE_NAME):$(VERSION)
