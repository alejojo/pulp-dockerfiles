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

# start the celerybeat image
start_beat_service() {
    # PULP_SERVER_NAME=$1
    # DB_SERVER_HOST=$2
    # MSG_SERVER_HOST=$3
    echo docker run -d --name pulp-beat \
        -v /dev/log:/dev/log \
        -e PULP_SERVER_NAME=$1 \
        -e DB_SERVER_HOST=$2 \
        -e MSG_SERVER_HOST=$3 \
        ${REGISTRY}/markllama/pulp-beat
}

# start the resource-manager image

# start a worker image

# start an apache image

# start a crane image

# ============================================================================
# MAIN
# ============================================================================
start_qpid_service
MSG_SERVER_HOST=$(docker_ip pulp-qpid)

start_db_service
DB_SERVER_HOST=$(docker_ip pulp-db)

start_beat_service $PULP_SERVER_NAME $DB_SERVER_HOST $MSG_SERVER_HOST
