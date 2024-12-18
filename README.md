# olge404.unix
This ansible collection is useful to streamline and ease the automated setup and configuration
of various software packages on different linux distros (e.g. ubuntu, debian, alpine and RHEL).

Not all roles are tested on all linux distros, but most are.

# Prerequisites
Run the [python-venv.sh](scripts/python-venv.sh) and [docker-install.sh](scripts/docker-install.sh) scripts to bootstrap
the virtuelenv for python and to install docker (on ubuntu).

Next, run `source .venv/bin/activate` to activate the python virtualenv in your shell and
`ansible-galaxy collection install -r requirements.yaml` to install the necessary collections.

To test that all prerequisites are fullfilled, run `scripts/ansible-test.sh` and `scripts/moluecule-tests.sh apt`.
This will run tests for the ansible collection and for the `apt` role. If those can be performed, you are good to go.

# Bootstrap a new role
Run the following commands to bootstrap the skeleton for a new role:

```bash
export ROLE_NAME="<roleName>"
cd roles
ansible-galaxy role init $ROLE_NAME
cd $ROLE_NAME
molecule init scenario --driver-name docker
```

# Test platforms
Roles in this collection are tested with various linux distros (test platforms). Testing is done by leveraging molecule as test framework 
and docker as driver to launch the test platforms. Because we are using docker, we need a container image for each test platform.

The Dockerfiles for this can be found in the [.molecule/platforms dir](.molecule/platforms/).
The [build.sh](.molecule/platforms/build.sh) script should be used to build, tag and push the container images to dockerhub.
All test platform need to be prepared to work with ansible and molecule. This includes:

* python3
* A non-root user to perform tests with and without sudo (molecule)
* passwordless sudo
