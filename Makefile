APP := $(shell basename -s .git $(shell git remote get-url origin) | tr '[:upper:]' '[:lower:]')
REGISTRY := PavelBabakin
DOCKER_USERNAME := backup0
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "unknown")
SHORT_HASH := $(shell git rev-parse --short HEAD)
TARGETOS := linux
TARGETARCH := arm64

format:
	gofmt -s -w ./

install-packages:
	go get -u ./...

lint:
	@which golint > /dev/null || (echo "Installing golint..." && go get -u golang.org/x/lint/golint)
	golint

test:
	go test -v

build: format
ifeq ($(VERSION),unknown)
	@echo "No Git tag found. Skipping build..."
else
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o buddyBot -ldflags "-X=github.com/${REGISTRY}/buddyBot/cmd.appVersion=${VERSION}-${SHORT_HASH}"
endif

image:
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-${TARGETARCH}

push:
	docker push ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-${TARGETARCH}

clean:
	rm -rf buddyBot
