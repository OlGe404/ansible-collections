# olge404.unix
This ansible collection is useful to streamline and ease the automated installation and configuration
of various software packages on unix-like operating systems (e.g. ubuntu, debian, alpine, RHEL and macOS).

The CI runs on Github actions and various shell scripts are used to perform installation, configuration and tests during a pipeline run. Each shell script provides a help function that describes how it can be used locally, which arguments can be provided etc. The help function can be accessed for any shell script by providing either the `-h` or `--help` argument when calling a script. For example:

```bash
scripts/python3-venv.sh --help
.molecule/platforms/build.sh -h
```

# Prerequisites
Run `scripts/python3-venv.sh` and `scripts/docker-install.sh` to bootstrap the virtuelenv for python and to install docker (on ubuntu).

Next, run `source .venv/bin/activate` to activate the python virtualenv in your shell and
`ansible-galaxy collection install -r requirements.yaml` to install all necessary ansible collections.

To test that all prerequisites are fullfilled, run `scripts/ansible-test.sh` and `scripts/molecule-tests.sh apt`.
This will run tests for the ansible collection and for the `apt` role. If those can be performed, you are good to go.

# Add more roles
Read and follow the next sections to understand what a new role should look like, how you can get a headstart and what this fuzz is all about.

## Bootstrapping
Run the following commands to bootstrap the skeleton for a new role:

```bash
export ROLE_NAME="<roleName>"
cd roles
ansible-galaxy role init $ROLE_NAME
cd $ROLE_NAME
molecule init scenario --driver-name docker
molecule test
```

This creates the default layout for a new role (following ansible best practices) and ensures that the `molecule test` setup works.
See `molecule --help` and https://ansible.readthedocs.io/projects/molecule/ for more information about testing ansible roles with molecule.

## Scope
Each role should serve one purpose like "install a package on a machine with a debian-like distro".
The goal is to keep each role as simple and concise as possible to ensure it can be tested properly and that it does what you would expect from it by reading its `README` file.

Good examples are roles like `apt`, `dnf` or `apk`. They are used for basic tasks and you might think "do I even need a role for that?" and the
answer is: YES! Using tested, reliable building blocks that adhere to best practices is a key element to build any reliable automation and that is what this collection was made for.

## Test platforms
Roles in this collection are tested on various unix-like operating systems (test platforms). Testing is done by leveraging molecule as test framework and docker as driver to launch these test platforms locally. This ensures repeatable test results by creating necessary test infrastructure on-demand in a simple way.

Because we are using docker, we need a container image for each platform we want to run our tests on. The Dockerfiles for these container images can be found in the [.molecule/platforms dir](.molecule/platforms/). The [build.sh](.molecule/platforms/build.sh) and [build-all.sh](.molecule/platforms/build-all.sh) scripts should be used to build, tag and push container images to dockerhub. The container images are referenced in the [molecule.yml file](roles/apt/molecule/default/molecule.yml) for a role to be used during tests.

All test platforms need to be prepared to work with ansible and molecule. This includes:

* Installing the python3, sudo and ca-certificates packages
* Creating a non-root user to perform tests with
* Enable passwordless sudo for the non-root user

See the [Dockerfile for Ubuntu 22.04](.molecule/platforms/Dockerfile.ubuntu-22.04) as an example onw how to prepare a test platform for testing with ansible and molecule.
