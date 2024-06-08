# Ansible Collection - olge404.unix

Documentation for the collection.

# Bootstrap a new role
export ROLE_NAME="<roleName>"
cd roles
ansible-galaxy role init $ROLE_NAME
cd $ROLE_NAME
molecule init scenario --driver-name podman

# Setup podman
https://podman.io/docs/installation#installing-on-linux
