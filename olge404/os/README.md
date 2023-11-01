# Intro
This collection is used to simplify the installation, configuration and testing for various software packages on multiple linux distros.
It shall be used to help improve the quality of automation pipelines and to keep the setup DRY, tested and concise.

The collection can be used to setup containers, VMs, etc. - basically anything that is based on a linux OS.

# Install the collection
Since the collection isn't published to the ansible-galaxy hub, the easiest way is to install it from this repository.

Use the following command to do so:
```bash
ansible-galaxy collection install git+https://github.com/OlGe404/ansible-collections.git#/olge404/os/,master
```

You can also specify it in the requirements.yaml file
```yaml
# requirements.yaml
---
collections:
  - name: git+https://github.com/OlGe404/ansible-collections.git#/olge404/os/
    version: master
```

and then install it as usual:
```bash
ansible-galaxy collection install -r requirements.yaml
```

When not using the requirements.yaml file, the version (branch) to install is specified after the `,` in the url.

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
You should copy/paste another role to have a valid starting point including the molecule test setup and edit it accordingly to do what you want.
Use [install_argocd_cli](roles/install_argocd_cli/README.md) as a simple example to get going.

### Supported platforms
The roles are tested on
* rhel-8
* debian-bullseye
* ubuntu-jammy

To see how the container images are used in a molecule test scenario, see this [molecule config file](roles/distro_packages/molecule/default/molecule.yml) as example.

## Run molecule tests
To run the molecule tests for a specific role, navigate to the roles root dir, e. g. [install_argocd_cli](roles/install_argocd_cli/).
From here you can start the test szenario(s) by running 

```bash
molecule test --all
```

To run molecule for a specific platform, which can be very useful when iterating/debugging a role, use

```bash
molecule test --all --platform-name=debian-bullseye
```

## Develop and debug roles with molecule
Sometimes you need to check what is going on during role development. Running your roles on localhost to test them is a bad idea, because this can break your development environment. Therefore the first step should be to ensure that
```bash
molecule create
```

AND

```bash
molecule destroy
```

works. If those commands fail, you are not able to provision and destroy your test infrastructure on demand to debug your roles.
If you copy/pasted another role, the molecule setup is copied too and the commands should work right away.

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
