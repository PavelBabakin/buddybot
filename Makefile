APP := $(shell basename -s .git $(shell git remote get-url origin) | tr '[:upper:]' '[:lower:]')
REGISTRY := PavelBabakin
DOCKER_USERNAME := backup0
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "unknown")
SHORT_HASH := $(shell git rev-parse --short HEAD)

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
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o ${APP} -ldflags "-X=github.com/${REGISTRY}/${APP}/cmd.appVersion=${VERSION}-${SHORT_HASH}"
endif

linux:
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-linux-amd64

arm:
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64

macos:
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-darwin-amd64

windows:
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-windows-amd64

push:
	docker push ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64

clean:
	docker rmi -f ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-linux-amd64
	docker rmi -f ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64
	docker rmi -f ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-darwin-amd64
	docker rmi -f ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-windows-amd64
