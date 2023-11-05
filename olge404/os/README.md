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
molecule should be run using the included Makefile. The Makefile ensures that molecule commands are executed with the proper config files to keep the test setup DRY.

Run `make` to execute "molecule test" for all roles.

Use `ROLES=<role_name> make` to run "molecule test" for a specific role.

Use `SEQUENCE=create make` to run "molecule create" for all roles 

.. and so on. You can combine the parameters as you like. You could use `ROLES=distro_packages SEQUENCE=converge make` to run "molecule converge" for the distro_packages role. You don't have to provide the parameters each time you invoke the make target - you can set them with e.g. "export ROLES=<role_name>" in your shell to not have to provide them each time.

## Develop and debug roles with molecule
Sometimes you need to check what is going on when developing a new role. Running your roles on localhost to see if they work is a bad idea, because this can break your development environment and doesn't provide a clean, deterministic starting point.

The first steps should be to ensure that
```bash
ROLES="<role_name>" SEQUENCE="create" make
```

AND

```bash
ROLES="<role_name>" SEQUENCE="destroy" make
```

work properly. If those commands fail, you are not able to provision/destroy your test infrastructure on demand to debug your roles.

**NOTE:** If you copy/pasted another role, the molecule setup is copied too and the commands should work right away.

After the create and destroy commands work, you can login to your instances using molecule to debug it.

If the test instance is called ``rhel-8``, you can login with

```bash
molecule login --host rhel-8
```

If the instance is called ``debian-bullseye``, you can use
```bash
molecule login --host debian-bullseye
```

... and so on. This will open a terminal via ssh to look around in the running instance. To see what instances are currently created, use `molecule list`.
