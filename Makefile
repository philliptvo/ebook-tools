# ===== Configuration =====
DOCKER_USERNAME   ?= quflop
IMAGE_NAME        ?= ebook-tools
TAG               ?= latest
FULL_IMAGE        := $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)

.PHONY: all build run test clean clean-all publish

# ===== Default target =====
all: build

# ===== Build Docker image =====
build:
	docker build -t $(FULL_IMAGE) .

# ===== Clean Test of Docker image =====
setup-test:
	if [ -d /tmp/library ]; then sudo rm -rf /tmp/library; fi
	cp -r assets /tmp/library
	sudo chown -R 568:568 /tmp/library/*

# ===== Test Docker image =====
test:
	docker run -it --rm --user 568:568 -v '/tmp/library:/library' $(FULL_IMAGE)

# ===== Clean (image only) =====
clean:
	docker rmi $(FULL_IMAGE) 2>/dev/null || true

# ===== Clean cache + artifacts =====
clean-all: clean
	docker builder prune -f

# ===== Publish =====
publish:
	docker push $(FULL_IMAGE)
