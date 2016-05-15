#!/usr/bin/env bash -e

function main {
  create_swarm_manager manager
  create_swarm_node agent1
  create_swarm_node agent2
}

function create_swarm_manager {
  local name=swarm-manager
  eval $(docker-machine env $1)
  docker stop $name
  docker rm $name
  docker run -d \
    --name $name \
    --restart always \
    -p 3376:3376 \
    -v /var/lib/boot2docker:/certs:ro \
    swarm:latest manage \
      -H 0.0.0.0:3376 \
      --tlsverify \
      --tlscacert /certs/ca.pem \
      --tlscert /certs/server.pem \
      --tlskey /certs/server-key.pem \
      consul://$(docker-machine ip $1):8500
  eval $(docker-machine env -u)
}

function create_swarm_node {
  local name=swarm-node
  eval $(docker-machine env $1)
  docker stop $name
  docker rm $name
  docker run -d \
    --name $name \
    --restart always \
    swarm:latest join \
      --addr $(docker-machine ip $1):2376 \
      consul://$(docker-machine ip $1):8500
  eval $(docker-machine env -u)
}

main
