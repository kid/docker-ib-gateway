NS ?= docker.pkg.github.com/kid/docker-ib-gateway
IMAGE_NAME ?= ib-gateway
CONTAINER_NAME ?= ib-tws
CONTAINER_INSTANCE ?= default

GITHUB_REF ?= "$(shell git rev-parse --abbrev-ref HEAD)"

ifneq (,$(findstring master, $(GITHUB_REF)))
	MYTAG ?= :latest
else ifneq (,$(findstring refs/tags/, $(GITHUB_REF)))
	MYTAG ?= :$(REF:refs/tags/%=%)
else
	MYTAG ?= :$(shell git rev-parse --short HEAD)
endif

.PHONY: build

build: Dockerfile
	export
	@echo GitHub REF: $(GITHUB_REF)
	@echo Foo: $(findstring master, $(GITHUB_REF))
	@echo Bar: $(findstring refs/tags/, $(GITHUB_REF))
	@echo Baz: $(shell git rev-parse --short HEAD)
	docker build -t $(NS)/$(IMAGE_NAME)$(MYTAG) -f Dockerfile .

run:
	docker run --rm -it \
		--name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) \
		-p 4000:4000 -p 4001:4001 -p 5900:5900 \
		--tmpfs /var:rw,exec \
		-e IB_USERNAME \
		-e IB_PASSWORD \
		-e VNC_PASSWORD \
		$(NS)/$(IMAGE_NAME)$(MYTAG)

push:
	docker push $(NS)/$(IMAGE_NAME)$(MYTAG)

test:
	@echo $(GITHUB_REF)
	@echo $(MYTAG)
	@echo $(findstring refs/tags/, $(GITHUB_REF))
