#!/bin/sh
set -x
#
# Start a Pulp service in docker
#
PULP_SERVER_NAME=${1:-pulp.example.com}

REGISTRY=${REGISTRY:=docker-registry.usersys.redhat.com}

docker_ip() {
    # CONTAINER_NAME=$1
    docker inspect --format="{{.NetworkSettings.IPAddress}}" $1
}

# start a qpid image
start_qpid_service() {
    docker run -d --name pulp-qpid ${REGISTRY}/markllama/qpid
}

# start a mongodb image
start_db_service() {
    docker run -d --name pulp-db ${REGISTRY}/markllama/mongodb
}

print_journal() {
    journalctl -f -l SYSLOG_IDENTIFIER=pulp + SYSLOG_IDENTIFIER=celery + SYSLOG_IDENTIFIER=httpd
}

# start the celerybeat service
start_beat_service() {
    # PULP_SERVER_NAME=$1
    # DB_SERVER_HOST=$2
    # MSG_SERVER_HOST=$3
    docker run -d --name pulp-beat \
        -v /dev/log:/dev/log \
        -e PULP_SERVER_NAME=$1 \
        -e DB_SERVER_HOST=$2 \
        -e MSG_SERVER_HOST=$3 \
        ${REGISTRY}/markllama/pulp-beat
}

# start the resource-manager
start_resource_manager_service() {
    # PULP_SERVER_NAME=$1
    # DB_SERVER_HOST=$2
    # MSG_SERVER_HOST=$3
    docker run -d --name pulp-resource-manager \
        -v /dev/log:/dev/log \
        -e PULP_SERVER_NAME=$1 \
        -e DB_SERVER_HOST=$2 \
        -e MSG_SERVER_HOST=$3 \
        ${REGISTRY}/markllama/pulp-resource-manager
}

# start the celerybeat image
start_content_volumes() {
    docker run -d --name pulp-content-volumes \
        ${REGISTRY}/markllama/pulp-content-volumes
}

# start a worker image
start_worker_service() {
    # PULP_SERVER_NAME=$1
    # DB_SERVER_HOST=$2
    # MSG_SERVER_HOST=$3
    # WORKER_NUMBER=$4
    docker run -d --name pulp-worker-$4 \
        -v /dev/log:/dev/log \
        --volumes-from pulp-content-volumes \
        -e PULP_SERVER_NAME=$1 \
        -e DB_SERVER_HOST=$2 \
        -e MSG_SERVER_HOST=$3 \
        ${REGISTRY}/markllama/pulp-resource-manager $4
}

# start an apache image
# start a worker image
start_apache_service() {
    # PULP_SERVER_NAME=$1
    # DB_SERVER_HOST=$2
    # MSG_SERVER_HOST=$3
    docker run -d --name pulp-apache \
        -v /dev/log:/dev/log \
        --volumes-from pulp-content-volumes \
        -e PULP_SERVER_NAME=$1 \
        -e DB_SERVER_HOST=$2 \
        -e MSG_SERVER_HOST=$3 \
        ${REGISTRY}/markllama/pulp-apache
}

# start a crane image

# ============================================================================
# MAIN
# ============================================================================
start_qpid_service
MSG_SERVER_HOST=$(docker_ip pulp-qpid)

start_db_service
DB_SERVER_HOST=$(docker_ip pulp-db)

exit

start_beat_service $PULP_SERVER_NAME $DB_SERVER_HOST $MSG_SERVER_HOST

# check qpid service for celery queue: requires qpid-tools package
#  qpid-config queues -b guest@${MSG_SERVER_HOST} celeryev
#  qpid-queue-states -a guest@${MSG_SERVER_HOST} celeryev

start_resource_manager_service $PULP_SERVER_NAME $DB_SERVER_HOST $MSG_SERVER_HOST

start_content_volumes

start_worker_service $PULP_SERVER_NAME $DB_SERVER_HOST $MSG_SERVER_HOST 1
start_worker_service $PULP_SERVER_NAME $DB_SERVER_HOST $MSG_SERVER_HOST 2
start_worker_service $PULP_SERVER_NAME $DB_SERVER_HOST $MSG_SERVER_HOST 3

start_apache_service $PULP_SERVER_NAME $DB_SERVER_HOST $MSG_SERVER_HOST
