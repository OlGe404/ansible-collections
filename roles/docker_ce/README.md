docker_ce
=========

Install docker-ce on on debian-based linux distros (ubuntu, linuxmint, etc.).

Requirements
------------

On the control node:

* [Requirements for the ansible.builtin.apt module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html#requirements)


On the target node:

* sudo privileges

Role Variables
--------------

All vars have empty default values set. If you don't provide any values for them, the tasks that use these vars won't have any effect on your system.

| Name                  | Type | Default | Description                                                                                |
| --------------------- | ---- | ------- | ------------------------------------------------------------------------------------------ |
| docker_ce_users        | list | []      | Usernames to add to the "docker" group. The user running ansible on the target machine will always be added, even if this var is empty. |
| docker_ce_daemon_json | dict | {}      | Content of the `/etc/docker/daemon.json` file. The file will be created, if it doesn't exists. If the content of this var changes, the `/etc/docker/daemon.json` file will be updated. If the `/etc/docker/daemon.json` file exists and this var is set to `{}`, the file will be deleted. Docker will always be restarted, if `/etc/docker/daemon.json` has changed (created, updated or deleted). |

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
- name: Install docker-ce
  hosts: all
  roles:
    - role: olge404.unix.docker_ce
      vars:
        docker_ce_users:
          - alice
          - bob
          - jenkins
          - runner
        
        docker_ce_daemon_json:
          {
            "log-driver": "json-file",
            "log-opts": {
              "max-size": "10m",
              "max-file": "3"
            }
          }
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
