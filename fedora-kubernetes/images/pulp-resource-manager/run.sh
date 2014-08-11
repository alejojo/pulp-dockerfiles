#!/bin/sh
set -x

check_variables() {
    if [ -z "$PULP_SERVER_NAME" ]
    then
        echo "Missing requires environment variable: PULP_SERVER_NAME"
        exit 2
    fi
}

start_resource_manager() {
       exec runuser apache \
      -s /bin/bash \
      -c "/usr/bin/celery worker -c 1 -n resource_manager@$PULP_SERVER_NAME \
          --events --app=pulp.server.async.app \
          --umask=18 \
          --loglevel=INFO -Q resource_manager \
          --logfile=/var/log/pulp/resource_manager.log"
}

# ---------------------------------------------------------------------------
# MAIN 
# ---------------------------------------------------------------------------

check_variables
start_resource_manager
