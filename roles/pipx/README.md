pipx
=========

Install python cli applications using pipx.
See https://github.com/pypa/pipx for more.

> NOTE: The installation of pipx is not managed by this role.
> You can use the "apt" or "pip" role from this collection to install pipx on your system.
> On macOS, you can use the "homebrew" role to do so.
> Refer to the linked pipx docs otherwise.

Requirements
------------

On the control node:

* ansible

On the target node:

* sudo privileges
* python3
* pipx >= 1.7.0

Role Variables
--------------

The `pipx_packages` var has an empty default value set. If you don't provide a list of `pipx_packages` to install, this role won't have any effect on your system.
 
| Name          | Type | Default | Description                                                                                       |
| ------------- | ---- | ------- | ------------------------------------------------------------------------------------------------- |
| pipx_packages | list | []      | List of pipx packages to install. See the [Example Playbook](#example-playbook) section for more. |

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
- name: Install pipx packages
  hosts: all
  roles:
    - role: olge404.unix.pipx
      vars:
        # List of pipx packages to install can be defined using these key/value pairs:
        # pipx_packages:
        #  - name: <name>
        #    global: <true|false> (default: false)>
        #    args: <list of args> (default: [])
        #
        # The key/value for "name" is mandatory. "global" and "args" are optional
        # because their default values are used when no value is provided.
        pipx_packages:
          - name: pycowsay

          - name: black
            # Install "black" system-wide.
            global: true
            # Arguments to append to the "pipx install" command.
            # Note that the "--global" arg is automatically appended if "global: true" is set.
            # Don't add the "--global" arg to the "args" list, but use "global: <true|false>" instead.
            args:
              - --python /usr/bin/python3
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
