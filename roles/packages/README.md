olge404.unix.packages
=========

Add remote package repositories and install packages for various distros in a generic,
declarative and tested way.

Requirements
------------

None.

Role Variables
--------------

| Name(type)           | Description                                                                                                                                            |
|----------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------:|
| packages_base(dict)  | Key/value pairs of base packages_base and their versions to install.                                                                                        |
| packages_extra(dict) | Key/value pairs of extra packages and their versions to install. Key/value pairs of "packages_extra" take precedence over "packages_base" entries, if both contain the same key. |
| packages_repos(dict) | Repos to add before installing packages.                                                                            |

Dependencies
------------

None.

Example Playbook
----------------
```yaml
- name: Install packages
  hosts: all
  roles:
    - role: olge404.unix.packages
      vars:
        packages_base:
          git: ""
          curl: ""
          gh: "2.43.0"

        packages_extra:
          terraform: ""
          packer: ""
          gh: "2.50.0" # takes precedance over 'gh: "2.43.0"' from packages_base

        packages_repos:
          hashicorp:
            repo: deb [signed-by=/etc/apt/keyrings/hashicorp.asc] https://apt.releases.hashicorp.com jammy main
            key_url: https://apt.releases.hashicorp.com/gpg
            key_dearmor: true

          github:
            repo: deb [arch=amd64 signed-by=/etc/apt/keyrings/github.gpg] https://cli.github.com/packages stable main
            key_url: https://cli.github.com/packages/githubcli-archive-keyring.gpg
            key_dearmor: false
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by OlGe404 (https://github.com/OlGe404).
