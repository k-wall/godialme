DOCKER_REGISTRY ?= quay.io
DOCKER_ORG ?= $(USER)
DOCKER_TAG ?= latest
BUILD_TAG ?= latest
PROJECT_NAME ?= godialme

BINARY ?= godialme
RELEASE_VERSION ?= 1.0

.PHONY: go_build
go_build:
	echo "Building Golang binary for ${RELEASE_VERSION}..."
	CGO_ENABLED=0 GOOS=linux go build -ldflags="-X 'main.version=${RELEASE_VERSION}'" -a -installsuffix cgo -o $(BINARY) godialme.go

.PHONY: go_clean
go_clean:
	echo "Cleaning Golang binary ..."
	rm -rf cmd/target

.PHONY: docker_build
docker_build:
	# Build Docker image ...
	echo "Building Docker image ..."
	docker build -t godialme/${PROJECT_NAME}:latest .
	# Also tag with $(BUILD_TAG)
	docker tag godialme/$(PROJECT_NAME):latest godialme/$(PROJECT_NAME):$(BUILD_TAG)

.PHONY: docker_save
docker_save:
	# Saves the container as TGZ file
	echo "Saving Docker image as tar.gz file ..."
	docker save godialme/${PROJECT_NAME}:${BUILD_TAG} | gzip > canary-container.tar.gz

.PHONY: docker_load
docker_load:
	# Loads the container as TGZ file
	echo "Loading Docker image from tar.gz file ..."
	docker load < canary-container.tar.gz

.PHONY: docker_tag
docker_tag:
	# Tag the $(BUILD_TAG) image we built with the given $(DOCKER_TAG) tag
	docker tag godialme/$(PROJECT_NAME):$(BUILD_TAG) $(DOCKER_REGISTRY)/$(DOCKER_ORG)/$(PROJECT_NAME):$(DOCKER_TAG)

.PHONY: docker_push
docker_push: docker_tag
	# Push the $(DOCKER_TAG)-tagged image to the registry
	echo "Pushing Docker image ..."
	docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/${PROJECT_NAME}:${DOCKER_TAG}
