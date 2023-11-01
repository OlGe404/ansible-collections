olge404.os.distro_packages
=========
Used to install software packages from built-in or additional repositories using the distribution specific
package manager, e. g. DNF or APT.

**Note:** The packages installed by this role should be used as they come. They should not require
additional setup after the installation. To install software packages that *do* require additional configiuration, use or create a role similar to
the `install_*` roles in this collection.

Requirements
------------
Run these commands from the [root dir of the collection](../..) to install all requirements:
```bash
python3 -m pip install --upgrade --user -r requirements.txt
ansible-galaxy collection install -r requirements.yaml --force
```

Role Variables
--------------
Overview of the vars used in this role. See [Example playbook usage](#Example-Playbook-usage) for more
details.

**_NOTE:_** See the [default vars](defaults/main.yml) before overwriting them in a playbook or otherwise.

| Name                      | Type | Explanation                                   |
| ------------------------- | ---- | --------------------------------------------- |
| distro_packages     | List | Names of the packages to install.             |
| distro_repositories | List | Repositories to add to install packages from. |

Dependencies
------------
None.

Example playbook usage
----------------
```yaml
- name: Example 
  hosts: all
  roles:
    - role: olge404.os.distro_packages
      vars:
        distro_packages: 
          - git
          - curl
          - packer
        
        distro_repositories:
          - name: hashicorp
            key_url: https://apt.releases.hashicorp.com/gpg
            # The string doesn't need the bracket notation for which apt key to use.
            # This is handled by the role automatically.
            repo: "deb https://apt.releases.hashicorp.com bullseye main"
```

License
-------
Apache-2.0

Author Information
------------------
Created by https://github.com/OlGe404
