tuxedo_tomte
=========

Install mikefarah/yq on linux.

Requirements
------------

On the control node:

* ansible

On the target node:

* sudo privileges

Role Variables
--------------

| Name       | Type   | Default | Description                                                                                                |
| ---------- | ------ | ------- | ---------------------------------------------------------------------------------------------------------- |
| yq_version | string | v4.44.6 | Version of yq to install. See "https://github.com/mikefarah/yq/releases" for a list of available versions. |

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
- name: Install yq
  hosts: all
  roles:
    - role: olge404.unix.yq
      vars:
        yq_version: "v4.44.5"
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
