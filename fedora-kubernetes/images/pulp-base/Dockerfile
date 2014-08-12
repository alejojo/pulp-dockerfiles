FROM fedora:20
MAINTAINER Mark Lamourine <markllama@gmail.com>

ADD http://repos.fedorapeople.org/repos/pulp/pulp/fedora-pulp.repo \
	/etc/yum.repos.d/rhel-pulp.repo

RUN yum update -y && \
    yum groupinstall -y pulp-server && \
    yum install -y qpid-cpp-server qpid-cpp-server-store \
         python-qpid-qmf python-qpid python-pulp-rpm-common && \
    yum install -y git findutils && \
    yum clean all

# install pulp_docker plugin to manage docker image repositories
RUN git clone https://github.com/pulp/pulp_docker.git /opt/pulp_docker

RUN /opt/pulp_docker/manage_setup_pys.sh develop

RUN python /opt/pulp_docker/pulp-dev.py -I

ADD server.conf /etc/pulp/server.conf
