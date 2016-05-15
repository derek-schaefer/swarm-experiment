#!/usr/bin/env bash -e

function main {
  create_consul_server manager
  create_consul_agent agent1
  create_consul_agent agent2
  create_registrator manager
  create_registrator agent1
  create_registrator agent2
}

function create_consul_server {
  local name=consul-server
  eval $(docker-machine env $1)
  docker stop $name
  docker rm $name
  docker run -d \
    --name $name \
    --restart always \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 8600:8600 \
    -p 8600:8600/udp \
    -p 53:8600/udp \
    gliderlabs/consul-server:latest \
      -bootstrap \
      -advertise $(docker-machine ip $1) \
      -data-dir /opt/consul/data \
      -ui
  eval $(docker-machine env -u)
}

function create_consul_agent {
  local name=consul-agent
  eval $(docker-machine env $1)
  docker stop $name
  docker rm $name
  docker run -d \
    --name $name \
    --restart always \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 8600:8600 \
    -p 8600:8600/udp \
    -p 53:8600/udp \
    gliderlabs/consul-server:latest \
      -join $(docker-machine ip manager) \
      -advertise $(docker-machine ip $1) \
      -ui
  eval $(docker-machine env -u)
}

function create_registrator {
  local name=registrator
  eval $(docker-machine env $1)
  docker stop $name
  docker rm $name
  docker run -d \
    --name $name \
    --net host \
    --restart always \
    -v /var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:latest \
      consul://localhost:8500
  eval $(docker-machine env -u)
}

main
