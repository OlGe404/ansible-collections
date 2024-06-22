olge404.unix.distro_packages
=========

Add package repositories and install distro_packages for various distros in a generic,
declarative and tested way.

Requirements
------------

None.

Role Variables
--------------

| Name(type)           | Description                                                                                                                                            |
|----------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------:|
| distro_packages_base(dict)  | Key/value pairs of base distro_packages_base and their versions to install.                                                                                        |
| distro_packages_extra(dict) | Key/value pairs of extra distro_packages and their versions to install. Key/value pairs of "distro_packages_extra" take precedence over "distro_packages_base" entries, if both contain the same key. |
| distro_packages_repos(dict) | Repos to add before installing distro_packages.                                                                            |

Dependencies
------------

None.

Example Playbook
----------------
```yaml
- name: Install distro_packages
  hosts: all
  roles:
    - role: olge404.unix.distro_packages
      vars:
        distro_packages_base:
          git: ""
          curl: ""
          gh: "2.43.0"

        distro_packages_extra:
          terraform: ""
          packer: ""
          gh: "2.50.0" # takes precedance over 'gh: "2.43.0"' from distro_packages_base

        distro_packages_repos:
          hashicorp:
            repo: deb [signed-by=/etc/apt/keyrings/hashicorp.asc] https://apt.releases.hashicorp.com jammy main
            key_url: https://apt.releases.hashicorp.com/gpg
            key_dearmor: true

          github:
            repo: deb [arch=amd64 signed-by=/etc/apt/keyrings/github.gpg] https://cli.github.com/distro_packages stable main
            key_url: https://cli.github.com/distro_packages/githubcli-archive-keyring.gpg
            key_dearmor: false
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by OlGe404 (https://github.com/OlGe404).
