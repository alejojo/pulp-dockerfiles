#!/bin/sh
#
#
cluster/kubecfg.sh -c play/mongodb.json create pods

cluster/kubecfg.sh -c play/mongodb-service.json create services

cluster/cubecfg.sh -c play/qpid.json create pods

cluster/kubecfg.sh -c play/qpid-service.json create services
