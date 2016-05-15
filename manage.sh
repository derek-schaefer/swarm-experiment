#!/usr/bin/env bash -e

function main {
  eval $(docker-machine env manager)
  docker -H $(docker-machine ip manager):3376 $@
  eval $(docker-machine env -u)
}

main $@
