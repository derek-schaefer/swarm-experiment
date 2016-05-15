all: build

build:
	./machines.sh
	sleep 10
	./discovery.sh
	sleep 10
	./swarm.sh
	sleep 10
	./shipyard.sh
