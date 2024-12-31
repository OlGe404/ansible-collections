pip
=========

Install pip packages into an venv for python3 (tested on debian-based distros).

> NOTE: The installation of necessary packages like python3, python3-venv and python3-packaging is not managed by this role.
> You can install those packages beforehand by using the "apt" role from this collection.

Requirements
------------

On the control node:

* ansible
* [Requirements for the ansible.builtin.pip module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/pip_module.html)

On the target node:

* sudo privileges
* python3 in PATH
* python3-venv
* python3-packaging

> NOTE: Other packages may be required if executed on a linux distro that is not debian-based (RHEL, CentOS, Fedora, etc.).

Role Variables
--------------

The `pip_packages` var has an empty default value set. If you don't provide a list of `pip_packages` to install, this role won't have any effect on your system.

See the [Example Playbook](#example-playbook) section for more.
 
| Name            | Type    | Default          | Description                                        |
| --------------- | ------- | ---------------- | -------------------------------------------------- |
| pip_packages    | list    | []               | List of pip packages to install.                   |
| pip_venv_dir    | string  | /opt/python/venv | Path of the virtualenv to install pip packages to. |

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
- name: Install pip packages
  hosts: all
  roles:
    - role: olge404.unix.pip
      vars:
        # List of pip packages to install.
        # Specify them in the format as you would when adding packages to a requirements.txt file
        # (with no spaces between package name and version identifiers).
        pip_packages:
          - ansible
          - molecule==24.12.0
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
