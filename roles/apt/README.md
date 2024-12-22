Apt
=========

Install apt packages on debian-like linux distros (ubuntu, mint, pop!os, etc.) from built-in or external apt repositories.

Requirements
------------

On the control node:

* python3
* ansible

On the target node:

* python3
* sudo privileges

Role Variables
--------------

All vars for this role have default values set, so they are all optional. If you don't provide any values yourself, the steps using those vars will be skipped.

> **NOTE**: See [Example Playbook](#example-playbook) section for more.

| Name                   | Type | Description                                                                                 |
| ---------------------- | ---- | ------------------------------------------------------------------------------------------- |
| apt_packages           | dict | Key/value pairs of apt packages to install.          |
| apt_packages_overwrite | dict | Key/value pairs of apt packages used to overwrite `apt_packages` var content, e.g. to specify a different version. |
| apt_repos              | dict | Key/value pairs of apt repos to add. The key/values to set follow the [deb822 specification](https://repolib.readthedocs.io/en/latest/deb822-format.html). |

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
- name: Install apt packages
  hosts: all
  roles:
    - role: olge404.unix.apt
      vars:
        # Dict of apt packages to install in the format of "<packageName>: <version>".
        # If <version> = "", the latest available version will be used.
        apt_packages:
          git: ""
          curl: ""
          gh: "2.43.0"
          terraform: ""
          packer: ""

        # Dict of packages to overwrite the content of "apt_packages" with.
        # In this example, version "2.50.0" of the "gh" package will be installed instead of version "2.43.0".
        # This is useful if you are layering configuration using group_vars and host_vars and want to overwrite specific
        # package versions on specific hosts.
        apt_packages_overwrite:
          gh: "2.50.0"

        # Dict of apt repos to add. Repos will be added an refreshed before package installation is attempted.
        apt_repos:
          # See https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt
          github:
            uri: https://cli.github.com/packages
            components: main
            suite: stable
            architecture: amd64
            key_url: https://cli.github.com/packages/githubcli-archive-keyring.gpg
            dearmor_key: false

          # See https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
          hashicorp:
            uri: https://apt.releases.hashicorp.com
            components: main
            # If "suite" is set to "auto", the value of "ansible_facts['distribution_release']" is used
            suite: auto
            # If "architecture" is set to "auto", the value of "ansible_facts['architecture']" is used
            architecture: auto
            key_url: https://apt.releases.hashicorp.com/gpg
            # You need to dearmor a GPG key for an APT repository if the key is provided in ASCII-armored format
            # (a text format typically beginning with "-----BEGIN PGP PUBLIC KEY BLOCK-----").
            # If you are unsure whether to dearmor the key or not, try setting this to 'false' first (or download the key and take a look at it yourself).
            dearmor_key: true
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
