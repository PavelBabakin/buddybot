APP := $(shell basename -s .git $(shell git remote get-url origin) | tr '[:upper:]' '[:lower:]')
REGISTRY := PavelBabakin
DOCKER_USERNAME := backup0
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "unknown")
SHORT_HASH := $(shell git rev-parse --short HEAD)
LAST_IMAGE := $(shell docker images -q | head -n 1)

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o ${APP} -ldflags "-X=github.com/${REGISTRY}/${APP}/cmd.appVersion=${VERSION}-${SHORT_HASH}"

linux: format get
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-linux-amd64

arm: format get
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64

macos: format get
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-darwin-amd64

windows: format get
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-windows-amd64

dive: image
	CI=true docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive \
	--ci --lowestEfficiency=0.99 ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64
	docker rmi -f ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64

image: build
	docker build . -t ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64

push:
	docker push ${DOCKER_USERNAME}/${APP}:${VERSION}-${SHORT_HASH}-arm-amd64

clean:
	@rm -rf ${APP}; \
	if [ -n "${LAST_IMAGE}" ]; then \
		docker rmi -f ${LAST_IMAGE}; \
	else \
		printf "Image not found\n"; \
	fi

