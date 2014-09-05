FROM fedora:20
MAINTAINER Mark Lamourine <markllama@gmail.com>

ADD https://repos.fedorapeople.org/repos/pulp/pulp/fedora-pulp.repo \
	/etc/yum.repos.d/fedora-pulp.repo

RUN yum groupinstall -y pulp-server && \
    yum install -y python-qpid-qmf python-qpid python-pulp-rpm-common && \
    yum install -y augeas && \
    yum clean all

# install pulp_docker plugin to manage docker image repositories
#RUN git clone https://github.com/pulp/pulp_docker.git /opt/pulp_docker
#RUN /opt/pulp_docker/manage_setup_pys.sh develop
#RUN python /opt/pulp_docker/pulp-dev.py -I

# Add an Augeas lens for managing Pulp INI files
ADD test_db_available.py /test_db_available.py
ADD pulpini.aug /usr/share/augeas/lenses/dist/pulpini.aug
ADD configure_pulp_server.sh /configure_pulp_server.sh
