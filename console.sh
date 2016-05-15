#!/usr/bin/env bash -e

function main {
  eval $(docker-machine env agent1)
  docker run -it --rm --dns 172.17.0.1 tutum/dnsutils
  eval $(docker-machine env -u)
}

main
