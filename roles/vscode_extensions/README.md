vscode_extensions
=========

Install and update vscode extensions using the "code" cli.

> NOTE: The installation of vscode is not managed by this role.
> Ensure vscode is installed beforehand, e.g. by using the `apt` or `snap` roles from this collection.
> See https://code.visualstudio.com/docs/setup/linux#_installation for more.

Requirements
------------

On the control node:

* python3
* ansible

On the target node:

* The "code" cli (that comes with vscode) has to be installed and in PATH

Role Variables
--------------

| Name              | Type | Default | Description                                                                                         |
| ----------------- | ---- | ------- | --------------------------------------------------------------------------------------------------- |
| vscode_extensions | list | []      | VS Code extensions to install. See the [Example Playbook](#example-playbook) section for more. |

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
- name: Install vscode extensions
  hosts: all
  roles:
    - role: olge404.unix.vscode_extensions
      vars:
        # To install an extension, add its ID to the list. The latest version will be installed.
        # To install a specific version, provide '${ID}@${version}', e. g. 'vscode.csharp@1.2.3'.
        # If an extension is already installed in the specified version, nothing happens.
        # If no version is specified, but a newer version is available, it will be updated. 
        #
        # You can find the ID of an extension in the settings of its marketplace website, e.g.
        # https://marketplace.visualstudio.com/items?itemName=redhat.ansible.
        # 
        # You can list all installed extensions with "code --list-extensions --show-versions".
        # 
        # See https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management for more.
        vscode_extensions:
          - hashicorp.hcl
          - redhat.ansible@24.12.1
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
