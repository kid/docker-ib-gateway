NS ?= docker.pkg.github.com/kid/docker-ib-gateway
IMAGE_NAME ?= ib-gateway
CONTAINER_NAME ?= ib-tws
CONTAINER_INSTANCE ?= default

GITHUB_REF ?= "$(shell git rev-parse --abbrev-ref HEAD)"

ifneq (,$(findstring master, $(GITHUB_REF)))
	TAG ?= :latest
else ifneq (,$(findstring refs/tags/, $(GITHUB_REF)))
	TAG ?= :$(GITHUB_REF:refs/tags/%=%)
else
	TAG ?= :$(shell git rev-parse --short HEAD)
endif

.PHONY: build

build: Dockerfile
	docker build -t $(NS)/$(IMAGE_NAME)$(TAG) -f Dockerfile .

run:
	docker run --rm -it \
		--name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) \
		-p 4000:4000 -p 4001:4001 -p 5900:5900 \
		--tmpfs /var:rw,exec \
		-e IB_USERNAME \
		-e IB_PASSWORD \
		-e VNC_PASSWORD \
		$(NS)/$(IMAGE_NAME)$(TAG)

push:
	docker push $(NS)/$(IMAGE_NAME)$(TAG)
