#!/bin/sh

# Display startup activity
set -x


# Take settings from Kubernetes service environment unless they are explicitly
# provided
PULP_SERVER_CONF=${PULP_SERVER_CONF:=/etc/pulp/server.conf}

PULP_SERVER_NAME=${PULP_SERVER_NAME:=pulp.example.com}

DB_SERVER_HOST=${DB_SERVER_HOST:=${SERVICE_HOST}}
DB_SERVER_PORT=${DB_SERVER_PORT:=21017}

MSG_SERVER_HOST=${MSG_SERVER_HOST:=${SERVICE_HOST}}
MSG_SERVER_PORT=${MSG_SERVER_PORT:=5672}

check_config_target() {
    if [ ! -f ${PULP_SERVER_CONF} ]
    then
        echo "Cannot find required config file ${PULP_SERVER_CONF}"
        exit 2  
    fi
}

#
# Set the Pulp service public hostname
#
configure_server_name() {
    sed -i -e "s/%PULP_SERVER_NAME%/${PULP_SERVER_NAME}/" ${PULP_SERVER_CONF}
}

#
# Set the messaging server access information
#
configure_messaging() {
    sed -i \
        -e "s/%MSG_SERVER_HOST%/${MSG_SERVER_HOST}/" \
        -e "s/%MSG_SERVER_PORT%/${MSG_SERVER_PORT}/" \
        $PULP_SERVER_CONF
}

#
# Set the database access information
#
configure_database() {
    sed -i \
        -e "s/%DB_SERVER_HOST%/${DB_SERVER_HOST}/" \
        -e "s/%DB_SERVER_PORT%/${DB_SERVER_PORT}/" \
        $PULP_SERVER_CONF
}

#
# Begin running the Celery Beat scheduler
# 
start_celerybeat() {
    exec runuser apache -s /bin/bash -c "/usr/bin/celery beat --workdir=/var/lib/pulp/celery --scheduler=pulp.server.async.scheduler.Scheduler -f /var/log/pulp/celerybeat.log -l INFO"
}

# =============================================================================
# Main
# =============================================================================
check_config_target

configure_server_name
configure_database
configure_messaging

start_celerybeat
