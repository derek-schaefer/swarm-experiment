#!/usr/bin/env bash -e

function main {
  create_rethinkdb
  create_controller
}

function create_rethinkdb {
  local name=shipyard-rethinkdb
  eval $(docker-machine env manager)
  docker stop $name
  docker rm $name
  docker run -d -it \
    --name $name \
    --restart always \
    rethinkdb:latest
  eval $(docker-machine env -u)
}

function create_controller {
  local name=shipyard-controller
  eval $(docker-machine env manager)
  docker stop $name
  docker rm $name
  docker run -d -it \
    --name $name \
    --restart always \
    --link shipyard-rethinkdb:rethinkdb \
    --link swarm-manager:swarm \
    -p 8080:8080 \
    -v /var/lib/boot2docker:/certs:ro \
    shipyard/shipyard:latest server \
      -d tcp://swarm:3376 \
      --tls-ca-cert /certs/ca.pem \
      --tls-cert /certs/server.pem \
      --tls-key /certs/server-key.pem
  eval $(docker-machine env -u)
}

main
