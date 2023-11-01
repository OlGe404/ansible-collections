# Intro
This collection is used to simplify the installation, configuration and testing for various software packages on multiple linux distros.
It shall be used to help improve the quality of automation pipelines and to keep the setup DRY, tested and concise.

The collection can be used to setup containers, VMs, etc. - basically anything that is based on a linux OS.

# Install the collection
Since the collection isn't published to the ansible-galaxy hub, the easiest way is to install it from this repository:
```bash
ansible-galaxy collection install git+https://github.com/OlGe404/ansible-collections.git#/olge404/os/,master
```

You can use a requirements.yaml file
```yaml
# requirements.yaml
---
collections:
  - name: git+https://github.com/OlGe404/ansible-collections.git#/olge404/os/
    version: master
```

and install it with:
```bash
ansible-galaxy collection install -r requirements.yaml
```

**NOTE:** When not using the requirements.yaml file, the version (branch) to install is specified after the `,` in the url.

## How to use roles from the collection
Each role has its own README file where the usage is explained in the `Example playbook usage` section, e.g. [distro_packages](roles/distro_packages/README.md).

## Local development and testing
Local development and testing is done with molecule. The test instances are based on pre-build, publicly available container images, that are prepared to run molecule tests using this [playbook](shared/prepare-container.yaml).

## Install local prerequisites
We need other collections and pip packages for our test setup to work. They can be found in the [requirements.yaml](requirements.yaml) and the [requirements.txt](requirements.txt) file.

To install the necessary collections, run
```bash
cd $(git rev-parse --show-toplevel)/olge404/os && \
ansible-galaxy collection install -r requirements.yaml
```

To install the pip packages, run
```bash
cd $(git rev-parse --show-toplevel)/olge404/os && \
python3 -m pip install --upgrade --user -r requirements.txt
```

You also need `podman` to spawn the containers that are used as test instances. Checkout the [podman docs](https://podman.io/docs/installation) on how to install it.

## Add a new role to the collection
You should copy/paste another role to have a valid starting point including the molecule test setup and edit it accordingly once the test setup works.
Use [install_argocd_cli](roles/install_argocd_cli/README.md) as a simple example to get going.

### Supported platforms
The roles are tested on these platforms:
* rhel-8
* debian-bullseye
* ubuntu-jammy

To see which container images are used in the molecule test scenarios, checkout the shared [molecule config file](shared/molecule.yml).

## Run molecule tests
To test a specific role, navigate to the root dir of the role, e.g. [install_argocd_cli](roles/install_argocd_cli/).
From there you can run the tests with 

```bash
molecule test --all
```

To run the tests for a specific platform only, use

```bash
molecule test --all --platform-name=debian-bullseye
```

## Develop and debug roles with molecule
Sometimes you need to check what is going on during role development. Running your roles on localhost to see if they work is a bad idea, because this can break your development environment and doesn't provide a clean, deterministic starting point.

The first steps should be to ensure that
```bash
molecule create
```

AND

```bash
molecule destroy
```

work properly. If those commands fail, you are not able to provision/destroy your test infrastructure on demand to debug your roles.

**NOTE:** If you copy/pasted another role, the molecule setup is copied too and the commands should work right away.

After ``molecule create`` and ``molecule destroy`` work, you can login to your instances using molecule.
If we assume your test instance is called ``rhel-8``, you can login with
```bash
molecule login --host rhel-8
```

If your test instance is called ``debian-bullseye``, you can use
```bash
molecule login --host debian-bullseye
```

... and so on. This will open a terminal via ssh to look around in the running instance.
