# Docker Swarm Experiment

Creates a local swarm environment for testing and evaluation.

## Requirements

* Docker Machine
* Virtualbox

## Usage

Create the swarm:

```shell
$ make
```

Open the Consul UI:

```shell
$ open http://$(docker-machine ip manager):8500
```

Open the Shipyard UI:

```shell
$ open http://$(docker-machine ip manager):8080
```

The default username/password is admin/shipyard.

## Containers

* Manager
  * Consul Server
  * Registrator
  * Swarm Manager
  * RethinkDB
  * Shipyard Controller
* Agent 1
  * Consul Agent
  * Registrator
  * Swarm Node
* Agent 2
  * Consul Agent
  * Registrator
  * Swarm Node
