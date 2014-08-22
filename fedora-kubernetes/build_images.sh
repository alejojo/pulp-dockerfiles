#!/bin/sh
#
# Build the docker images for a Pulp service
#
REGISTRY=${1:-docker-registry.usersys.redhat.com}
DEVUSER=${2:-markllama}
docker build -t ${REGISTRY}/${DEVUSER}/mongodb images/mongodb
docker build -t ${REGISTRY}/${DEVUSER}/qpid images/qpid
docker build -t ${REGISTRY}/${DEVUSER}/pulp-base images/pulp-base
docker build -t ${REGISTRY}/${DEVUSER}/pulp-beat images/pulp-beat
docker build -t ${REGISTRY}/${DEVUSER}/pulp-resource-manager images/pulp-resource-manager
docker build -t ${REGISTRY}/${DEVUSER}/pulp-content-volumes images/pulp-content-volumes
docker build -t ${REGISTRY}/${DEVUSER}/pulp-worker images/pulp-worker
docker build -t ${REGISTRY}/${DEVUSER}/pulp-apache images/pulp-apache
