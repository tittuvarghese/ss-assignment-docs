#!/bin/bash

BASE=$PWD

build_service() {
  local service_path=$1
  local output_name=$2
  local base_path=$3
  cd $service_path || exit
  rm -f bin/*
  # go mod tidy
  CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o "bin/$output_name" cmd/main.go
  if [ $? -ne 0 ]; then
    echo "Error building $service_path"
    exit 1
  fi
  cp "bin/$output_name" "$base_path/bin/$output_name"
}

# Build services
rm -f bin/*
build_service "../ss-go-gateway" "gateway" $BASE
build_service "../ss-go-customer-service" "customer-service"  $BASE
build_service "../ss-go-order-management-service" "order-management-service"  $BASE
build_service "../ss-go-product-service" "product-service"  $BASE

cd $BASE
docker rmi -f tittuvarghese/scalableservice:latest
docker build -f Dockerfile -t tittuvarghese/scalableservice:latest .
docker-compose -f deployment/docker-compose-app.yaml up -d