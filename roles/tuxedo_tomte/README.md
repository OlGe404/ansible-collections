tuxedo_tomte
=========

Install tuxedo-tomte on supported platforms (TUXEDO OS, Ubuntu 20.04, 22.04, and 24.04 - including directly based distributions such as Linux Mint, Kubuntu, Xubuntu, and Ubuntu MATE).

Requirements
------------

On the control node:

* [Requirements for the ansible.builtin.apt module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html#requirements)

On the target node:

* sudo privileges

Role Variables
--------------

| Name                   | Type   | Default | Description                                                                                |
| ---------------------- | ------ | ------- | ------------------------------------------------------------------------------------------ |
| tuxedo_tomte_version   | string | 2.40.2  | Version of tuxedo-tomte to install. See https://deb.tuxedocomputers.com/ubuntu/pool/main/t/tuxedo-tomte/ for a list of available versions. |

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
- name: Install tuxedo-tomte
  hosts: all
  roles:
    - role: olge404.unix.tuxedo_tomte
      vars:
        tuxedo_tomte_version: "2.39.2"
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
