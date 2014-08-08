FROM fedora:20
MAINTAINER Mark Lamourine <markllama@gmail.com>

COMMENT { "description": "mongodb service container", \ 
          "usage": "docker run -d -p 27017:27017 --name mongodb fedora/mongodb --volume=/mydbdatadir:/var/lib/mongodb" }

RUN  yum install -y mongodb-server && \
     yum clean all

RUN  mkdir -p /var/lib/mongodb && \
     touch /var/lib/mongodb/.keep && \
     chown -R mongodb:mongodb /var/lib/mongodb

VOLUME ["/var/lib/mongodb"]

USER mongodb

ADD mongodb.conf /etc/mongodb.conf

EXPOSE 27017
CMD ["/usr/bin/mongod", "--quiet", "--config", "/etc/mongodb.conf", "run"]
