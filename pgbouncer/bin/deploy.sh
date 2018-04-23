#!/usr/bin/env bash

IMAGE_NAME="314695318048.dkr.ecr.ap-northeast-2.amazonaws.com/thirdparty/pgbouncer:$(git rev-parse --short HEAD)"

$(aws ecr get-login --no-include-email --region ap-northeast-2)
docker build -t "${IMAGE_NAME}" .
docker push "${IMAGE_NAME}"
