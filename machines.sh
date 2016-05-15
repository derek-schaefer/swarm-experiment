#!/usr/bin/env bash -e

function main {
  create_machine manager
  create_machine agent1
  create_machine agent2
}

function create_machine {
  docker-machine create -d virtualbox $1
}

main
