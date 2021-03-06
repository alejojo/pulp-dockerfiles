#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "USAGE: `basename $0` <pulp_hostname>"
  exit 1
fi

PULP_HOSTNAME=$1

echo "Pulling docker images"

IMAGES=( "aweiteka/pulp-admin" \
         "aweiteka/pulp-publish-docker" )
for i in "${IMAGES[@]}"; do sudo docker pull $i; done

echo "Setting up ~/.pulp directory"

mkdir ~/.pulp
chcon -Rvt svirt_sandbox_file_t ~/.pulp

cat << EOF > ~/.pulp/admin.conf
[server]
host = $PULP_HOSTNAME
verify_ssl = False
EOF

cat << EOF > ~/.pulp/publish.conf
[redirect]
url=http://$PULP_HOSTNAME
EOF

ls -l ~/.pulp

echo "Create /run/docker_uploads"
sudo mkdir -p /run/docker_uploads
sudo chcon -Rv -u system_u -t svirt_sandbox_file_t /run/docker_uploads

echo "Update ~/.bashrc with aliases"
echo "alias pulp-admin='sudo docker run --rm -t -v ~/.pulp:/.pulp -v /run/docker_uploads/:/run/docker_uploads/ aweiteka/pulp-admin'" >> ~/.bashrc
echo "alias pulp-publish-docker='sudo docker run --rm -i -t -v ~/.pulp:/.pulp -v /run/docker_uploads/:/run/docker_uploads/ aweiteka/pulp-publish-docker'" >> ~/.bashrc

echo "2 aliases added to ~/.bashrc"

echo "Install complete"
echo "Run \"source ~/.bashrc\" to update aliases in the current shell."
echo "Then login with command \"pulp-admin login -u <username> -p <password>\""
