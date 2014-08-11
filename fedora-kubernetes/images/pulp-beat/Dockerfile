#
# Pulp Celerybeat service - coordinate activities
#
FROM docker-registry.usersys.redhat.com/markllama/pulp-base

ADD server.conf /etc/pulp/server.conf
ADD run.sh /run.sh

CMD [ "/run.sh" ]
