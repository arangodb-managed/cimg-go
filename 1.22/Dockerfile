# vim:set ft=dockerfile:

# Do not edit individual Dockerfiles manually. Instead, please make changes to the Dockerfile.template, which will be used by the build script to generate Dockerfiles.

# By policy, the base image tag should be a quarterly tag unless there's a
# specific reason to use a different one. This means January, April, July, or
# October.
#FROM cimg/base:2023.07

# Oasis added begin
ARG CIMGBASETAG
FROM arangodboasis/cimg-base:${CIMGBASETAG}

ARG GO_VERSION
# Oasis added end

LABEL maintainer="CircleCI Execution Team <eng-execution@circleci.com>"

ENV GO_VER=${GO_VERSION}

# Install packages needed for CGO
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
		g++ \
		libc6-dev && \
	sudo rm -rf /var/lib/apt/lists/* && \
	[[ $(uname -m) == "x86_64" ]] && ARCH="amd64" || ARCH="arm64" && \
	curl -sSL "https://go.dev/dl/go${GO_VER}.linux-${ARCH}.tar.gz" | sudo tar -xz -C /usr/local/ && \
	mkdir -p /home/circleci/go/bin

ENV GOPATH /home/circleci/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Install related tools
ENV GOTESTSUM_V=1.11.0
ENV GOCI_LINT_V=1.55.2
ENV GOVULNCHECK_V=1.0.1

RUN [[ $(uname -m) == "x86_64" ]] && ARCH="amd64" || ARCH="arm64" && \
	curl -sSL "https://github.com/gotestyourself/gotestsum/releases/download/v${GOTESTSUM_V}/gotestsum_${GOTESTSUM_V}_linux_${ARCH}.tar.gz" | \
	sudo tar -xz -C /usr/local/bin gotestsum && \
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sudo sh -s -- -b /usr/local/bin v${GOCI_LINT_V} && \
	go install "golang.org/x/vuln/cmd/govulncheck@v${GOVULNCHECK_V}" && go clean -cache -modcache && rm -rf "${GOPATH}/pkg"
