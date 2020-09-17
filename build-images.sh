#!/usr/bin/env bash

docker build --file 1.15/Dockerfile -t cimg/go:1.15.2  -t cimg/go:1.15 .
docker build --file 1.15/node/Dockerfile -t cimg/go:1.15.2-node  -t cimg/go:1.15-node .
docker build --file 1.15/browser-base/Dockerfile -t cimg/go:1.15.2-browser-base  -t cimg/go:1.15-browser-base .
