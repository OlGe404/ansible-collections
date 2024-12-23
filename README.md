# olge404.unix
This ansible collection is useful to streamline and ease the automated installation and configuration
of various software packages on unix-like operating systems (e.g. ubuntu, debian, linuxmint, alpine, almalinux, RHEL and macOS).

# Usage and docs
To install this collection, run:

```bash
ansible-galaxy collection install olge404.unix
```

Documentation for this collection and each role can be found on [GitHub](https://github.com/OlGe404/olge404.unix/blob/main/README.md) or on [ansible-galaxy hub](https://galaxy.ansible.com/ui/repo/published/olge404/unix/docs/).

# Development
The code is [hosted on Github](https://github.com/OlGe404/olge404.unix) and CI is done on [GitHub actions](https://github.com/OlGe404/olge404.unix/actions). The CI uses [various shell scripts](https://github.com/OlGe404/olge404.unix/tree/main/scripts) to perform installation, configuration and tests during a pipeline run. Each shell script provides a help function that describes how the script can be used. The help function can be called by providing either the `-h` or `--help` argument when running a script. For example:

```bash
scripts/python3-venv.sh --help
scripts/build-container.sh -h
```

## Prerequisites
To install yq, bootstrap the virtuelenv for python and to install docker, run:

```bash
scripts/yq-install.sh
scripts/python3-venv.sh
scripts/docker-install.sh
```

To activate the python virtualenv in your shell and to install required ansible collections, run:

```bash
source .venv/bin/activate
scripts/ansible-galaxy-requirements.sh
```

To test that all prerequisites are fullfilled, and tests for the collection and roles can be performed, run:

```bash
scripts/ansible-test-sanity.sh
scripts/molecule-test.sh apt
```

If those commands work, you are good to go.

## Add more roles
Read and follow the next sections to understand what a new role should look like, how you can get a headstart and what this fuzz is all about.

### Bootstrapping
Run the following commands to bootstrap the skeleton for a new role:

```bash
export ROLE_NAME="<ROLE_NAME>"
cd roles
ansible-galaxy role init $ROLE_NAME
cd $ROLE_NAME
molecule init scenario --driver-name docker
molecule test
```

This creates the default layout for a new role (following ansible best practices) and ensures that the `molecule test` setup works.

See `molecule --help` and https://ansible.readthedocs.io/projects/molecule/ for more information about testing ansible roles using molecule.

### Scope
Each role should serve one purpose like "install a package on a debian-like distro".
The goal is to keep each role as simple and concise as possible to ensure it can be tested properly and that it does what you would expect from it by reading its `README` file.

Good examples are roles like `apt`, `dnf` or `apk`. They are used for basic tasks and you might think "do I even need a role for that?" and the
answer is: YES! Using tested, reliable building blocks that adhere to best practices is a key element to build any reliable automation and that is what this collection was made for.

### Test platforms
Roles in this collection are tested on various unix-like operating systems (test platforms). Testing is done by leveraging molecule as test framework and docker as driver to launch these test platforms locally. This ensures predictable test results by creating the test infrastructure on-demand in a simple and repeatable manner.

Because we are using docker, we need a container image for each platform we want to run our tests on. The Dockerfiles for these container images can be found in the [.molecule/platforms dir](https://github.com/OlGe404/olge404.unix/tree/main/.molecule/platforms/). The [docker-build.sh](https://github.com/OlGe404/olge404.unix/tree/main/scripts/docker-build.sh) script should be used to build, tag and push container images to dockerhub (if you need to build them manually). The CI will build and push all container images at least once per week, or if any Dockerfile has changed in the ".molecule/platforms" dir. The container images are referenced in the [molecule.yml file](https://github.com/OlGe404/olge404.unix/tree/main/roles/apt/molecule/default/molecule.yml) of a role to be used during molecule tests.

All test platforms need to be prepared to work with ansible and molecule. This includes:

* Installing the python3, sudo and ca-certificates packages
* Creating a non-root user to perform tests with
* Enable passwordless sudo for the non-root user

See the [Dockerfile for Ubuntu 24.04](https://github.com/OlGe404/olge404.unix/tree/main/.molecule/platforms/Dockerfile.ubuntu-24.04) as an example on how to prepare a test platform for molecule.

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
