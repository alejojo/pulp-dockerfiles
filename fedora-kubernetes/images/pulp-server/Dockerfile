FROM fedora:20
MAINTAINER Mark Lamourine <markllama@gmail.com>

VOLUME [ "/etc/pulp", "/var/www", "/var/lib/pulp", "/opt/pulp_docker" ]

ADD http://repos.fedorapeople.org/repos/pulp/pulp/fedora-pulp.repo \
	/etc/yum.repos.d/rhel-pulp.repo

RUN yum -y install yum-utils 

RUN yum-config-manager --disable pulp-v2-stable && \
    yum-config-manager --enable pulp-v2-beta

RUN yum update -y && \
    yum groupinstall -y pulp-server && \
    yum install -y qpid-cpp-server qpid-cpp-server-store \
         python-qpid-qmf python-qpid python-pulp-rpm-common && \
    yum clean all

RUN yum install -y git findutils && yum clean all

# install pulp_docker plugin to manage docker image repositories
RUN git clone https://github.com/pulp/pulp_docker.git /opt/pulp_docker

RUN /opt/pulp_docker/manage_setup_pys.sh develop

RUN python /opt/pulp_docker/pulp-dev.py -I

# HACK: may not be needed
RUN touch /etc/pulp/vhosts80/blank.conf

ADD run.sh /run.sh

# Usage: /run.sh worker|beat|resource_manager [<unique_worker_number>]
ENTRYPOINT ["/run.sh"]
