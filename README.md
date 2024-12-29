# olge404.unix
This ansible collection is useful to streamline and ease the automated installation and configuration
of various software packages on unix-like operating systems (popular linux distros and macOS).

Most roles are tested on these linux distros (when applicable):

* Ubuntu: 24.04 (noble numbat)
* Debian: 12 (bookworm)
* Linux Mint: 22 (wilma)

and some roles are tested on:

* macOS 15 (Sequoia)

> Note: You can always check on what platforms a role was tested on by checking its [molecule setup on github](https://github.com/OlGe404/olge404.unix/blob/main/roles/apt/molecule/default/molecule.yml).

# Usage and docs
To install this collection, run:

```bash
# Latest
ansible-galaxy collection install olge404.unix

# Specific version
ansible-galaxy collection install olge404.unix:x.y.z
```

Available versions and documentation for this collection can be found on [GitHub](https://github.com/OlGe404/olge404.unix/blob/main/README.md) and on [ansible-galaxy hub](https://galaxy.ansible.com/ui/repo/published/olge404/unix/docs/).

# Development
The code is [hosted on Github](https://github.com/OlGe404/olge404.unix) and CI is done on [GitHub actions](https://github.com/OlGe404/olge404.unix/actions). The CI uses [various shell scripts](https://github.com/OlGe404/olge404.unix/tree/main/scripts) to perform installation, configuration and tests during a pipeline run. Each shell script provides a help function that describes how the script can be used. The help function can be called by providing either the `-h` or `--help` argument when running a script. For example:

```bash
scripts/python3-venv.sh --help
scripts/build-container.sh -h
```

The CI pipelines can be found in the [.github/workflows](https://github.com/OlGe404/olge404.unix/tree/main/.github/workflows) dir.

## Prerequisites
To develop roles for this collection, some tools are necessary. These are:

| Name                                        | Docs          |
|---------------------------------------------|---------------|
| ansible                                     | https://docs.ansible.com/ansible/latest/installation_guide/ |
| molecule (+ drivers for docker and vagrant) | https://ansible.readthedocs.io/projects/molecule/installation/ |
| docker                                      | https://docs.docker.com/engine/install/  |
| vagrant                                     | https://developer.hashicorp.com/vagrant/docs/installation |
| virtualbox                                  | https://www.virtualbox.org/wiki/Downloads |
| yq                                          | https://mikefarah.gitbook.io/yq#install |

You can use the following scripts and playbooks to automate the installation on your machine.

### Setup dev environment
To setup the virtual environment for python and install ansible, molecule and the required drivers in it, run:

```bash
scripts/python3-venv.sh
```

Next, activate the python virtualenv in your shell and install this collection:

```bash
source .venv/bin/activate
ansible-galaxy collection install olge404.unix
```

To install docker, yq, vagrant and virtualbox, use the dev-setup playbook. The dev-setup playbook is supported on Ubuntu 24.04, Debian 12 and Linux Mint 22. If you are not developing of one of those distros, refer to the docs listed above to install the prerequisites by yourself.

```bash
ansible-playbook playbooks/dev-setup.yml
```

To test that everything works, run:

```bash
# Run sanity tests for the collection
scripts/ansible-test-sanity.sh

# Run tests using the docker driver for molecule
scripts/molecule-test.sh apt

# Run tests using the vagrant driver for molecule
scripts/molecule-test.sh docker_ce
```

### Scope
Each role should serve one purpose like "install a package on a debian-like distro".
The goal is to keep each role as simple and concise as possible to ensure it can be tested properly and that it does what you would expect from it by reading its `README` file.

Good examples are roles like `apt` or `vscode_extensions`. They are used for basic tasks and you might think "do I even need a role for that?" and the
answer is: YES! Using tested, reliable building blocks that adhere to best practices is a key element to build any reliable automation and that is what this collection was made for.

### Test platforms
Roles in this collection are tested on various unix-like operating systems (test platforms). Testing is done by leveraging molecule as test framework and docker or vagrant as driver to launch these test platforms. This ensures predictable test results by creating test infrastructure on-demand in a simple and repeatable manner.

#### Testing with docker
Because we are using docker for some tests, a container image is needed for each platform we want to run our tests on. The Dockerfiles can be found in the [.molecule/platforms dir](https://github.com/OlGe404/olge404.unix/tree/main/.molecule/platforms/).

The [docker-build.sh](https://github.com/OlGe404/olge404.unix/tree/main/scripts/docker-build.sh) script should be used to build, tag and push container images to dockerhub (if you need to build them manually). The CI will build and push all container images at least once per week automatically (at midnight every Monday).

To use these container images for testing, reference them in the [molecule.yml file](https://github.com/OlGe404/olge404.unix/tree/main/roles/apt/molecule/default/molecule.yml) of a role. You can find current tags on [dockerhub](https://hub.docker.com/repository/docker/olge404/molecule/general).

##### Adding more test platforms for docker
All container images need to be prepared to work with ansible and molecule when using the docker driver. This includes:

* Installing the python3, sudo and ca-certificates packages
* Creating a non-root user to perform tests with
* Enable passwordless sudo for the non-root user

See the [Dockerfile for Ubuntu 24.04](https://github.com/OlGe404/olge404.unix/tree/main/.molecule/platforms/Dockerfile.ubuntu-24.04) as an example on how to prepare a test platform for molecule.

#### Testing with vagrant
Sometimes you need a full fledged virtual machine (VM) to test roles properly (e.g. because they rely on software that containers are finicky with or are not ideal for). In those cases, vagrant and virtualbox are used to spin up VMs on-demand to use as test platforms for molecule.

VMs that are managed with vagrant are called "boxes" and we don't build custom boxes for this repository (yet). We use pre-build [bento boxes](https://github.com/chef/bento) that are ready to be used as test platforms with molecule and vagrant.

Checkout the [molecule + vagrant setup](https://github.com/OlGe404/olge404.unix/tree/main/roles/docker_ce/molecule/default/molecule.yml) for the `docker_ce` role as example.

> NOTE: Docker should be used to launch test platforms wherever possible,
> because container images are smaller, faster and easier to work with than VMs.

# Changelog
All notable changes to this collection have to be listed in the [changelog.md file](https://github.com/OlGe404/olge404.unix/tree/main/changelog.md) and have to follow [semantic versioning](https://semver.org/).

The changelog.md file adheres to the conventions listed on [keepachangelog.com](https://keepachangelog.com/en/1.1.0/).

Here is a quick overview:

```
Guiding Principles
    Changelogs are for humans, not machines.
    There should be an entry for every single version.
    The same types of changes should be grouped.
    Versions and sections should be linkable.
    The latest version comes first.
    The release date of each version is displayed.
    Mention whether you follow Semantic Versioning.

Types of changes
    [Added] for new features.
    [Changed] for changes in existing functionality.
    [Deprecated] for soon-to-be removed features.
    [Removed] for now removed features.
    [Fixed] for any bug fixes.
    [Security] in case of vulnerabilities.

Keep an [UNRELEASED] section at the top to track upcoming changes. This serves two purposes:
    People can see what changes they might expect in upcoming releases
    At release time, you can move the [UNRELEASED] section changes into a new release version section.
```

# Release a new version
The [release.yml pipeline](https://github.com/OlGe404/olge404.unix/tree/main/.github/workflows/release.yml) is used to test, build and publish a new version of this collection to ansible-galaxy hub if a release-tag is pushed.

Before attempting to release a new version, update the `version` field in the [galaxy.yml file](https://github.com/OlGe404/olge404.unix/tree/main/galaxy.yml). The release pipeline will check if the version of the release-tag matches the `version` field in the galaxy.yml file and will fail, if it doesn't match. It will also fail if the version you are trying to release already exists on ansible-galaxy hub.

If you forgot to update the `version` field in the galaxy.yml file, but already pushed a release-tag and the release pipeline fails, you have to:

* Update the version in the galaxy.yml file and push it
* Delete the failed release-tag locally and remote
* Create and push a new annotated release-tag to retry the release

Here is a cheatsheet on how to list, delete and create new git tags to perform a release. The release pipeline will be triggered if a tag is pushed that matches `release-X.Y.Z`.

```bash
# Get version from galaxy.yml file
RELEASE_VERSION=$(yq .version galaxy.yml)

# List all tags
git tag

# Create and push a new tag
git tag -a release-$RELEASE_VERSION -m "Release version $RELEASE_VERSION"
git push origin release-$RELEASE_VERSION

# Delete tag locally and remote (if release pipeline failed)
git tag -d release-$RELEASE_VERSION
git push origin --delete release-$RELEASE_VERSION
```
