# Ansible Collection - olge404.os
This collection is used to simplify the installation, configuration and testing for various software packages on multiple linux distros.
It shall be used to help improve the quality in automation pipelines and to keep git repositories DRY and concise.

The collection can be used to setup containers, VMs, etc. - basically anything that is based on a linux OS.

# Install the collection
To use the collection, you have to install it first. This can be done by providing a version and url to install the collection from.
Since the collection isn't published to the ansible-galaxy hub, the easiest way to install it is from this git repository.

You can install it  with the following command:
```bash
ansible-galaxy collection install git+https://github.com/OlGe404/ansible-collections.git#/olge404/os/,master
```

You can also provide a requirements.yaml file with the collection spec in it
```yaml
# requirements.yaml
---
collections:
  - name: git+https://github.com/OlGe404/ansible-collections.git#/olge404/os/
    version: master
```

and then use the file for the installation as usual:
```bash
ansible-galaxy collection install -r requirements.yaml
```

When not using the requirements.yaml file, the version is specified after the `,` in the url. Be sure to use ``git+https`` as protocol in the url, otherwise the installation might fail.

## How to use roles from the collection
How to use each role is explained in the ``Example Playbook usage`` section of the README.md file for each role.

# Local development and testing
Local development and testing is done with molecule. The test instances are based on pre-build, publicly available container images.

## Install local prerequisites
We need other collections and pip packages for our test setup. They can be found in the [requirements.yaml](requirements.yaml) and the [requirements.txt](requirements.txt) file.

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

## Add a new role to the collection
To add a new role to the collection, copy/paste another role to have a valid starting point including the molecule test setup.
You should use the [install_argocd_cli](roles/install_argocd_cli/README.md) role because it is a simple example and a good starting point.

## Build the container images to use in molecule tests
To build the container images used for the molecule tests, export your AWS ENVs as follows

### Supported platforms
The roles are tested on:
* rhel-8
* debian-bullseye
* debian-bookworm

To see how the container images are used in a molecule test scenario, see this
[molecule config file](roles/install_argocd_cli/molecule/default/molecule.yml) as an example.

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
Sometimes you need to check what is going on during role development. The first step should be to ensure that
```bash
molecule create
```
AND
```bash
molecule destroy
```
work for your role. If those commands fail, you are not able to provision and destroy your test infrastructure
on demand and cannot debug your roles. Running your roles on localhost to test them is a bad idea, because this can break your development environment.

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
