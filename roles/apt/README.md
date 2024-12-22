Apt
=========

Install apt packages on debian-like linux distros (ubuntu, mint, pop!os, etc.) from built-in or external apt repositories.

Requirements
------------

On the control node:

* [Requirements for the ansible.builtin.apt module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html#requirements)


On the target node:

* sudo privileges

Role Variables
--------------

All vars for this role have empty default values set. If you don't provide your own values for them, the steps using those vars will be skipped.

> **NOTE**: See [Example Playbook](#example-playbook) section for more.

| Name                   | Type | Default | Description                                                                                |
| ---------------------- | ---- | ------- | ------------------------------------------------------------------------------------------ |
| apt_packages           | dict | {}      | Key/value pairs of apt packages to install in the format of `packageName: packageVersion`. See the [Example Playbook](#example-playbook) section for more. |
| apt_packages_overwrite | dict | {}      | Key/value pairs of packages to overwrite `apt_packages`, e.g. to specify a different version. See the [Example Playbook](#example-playbook) section for more. |
| apt_repos              | dict | {}      | Key/value pairs of apt repos to add. The keys follow the [deb822 specification](https://repolib.readthedocs.io/en/latest/deb822-format.html) for apt sources managed in `/etc/apt/sources.list.d`. See the [Example Playbook](#example-playbook) section for more. |

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
        # Dict of apt packages to install in the format of "<packageName>: <packageVersion>".
        # If <packageVersion> = "", the latest available version will be used.
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

        # Dict of apt repos to add. Sources will be added and refreshed before package installations. Order of the keys don't matter.
        apt_repos:
          # The github key/values are extracted from the following one-line string of the github docs:
          # echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"
          #
          # See https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt for more.
          github:
            architecture: amd64
            key_url: https://cli.github.com/packages/githubcli-archive-keyring.gpg
            uri: https://cli.github.com/packages
            suite: stable
            components: main
            dearmor_key: false

          # The hashicorp key/values are extracted from the following one-line string of the hashicorp docs:
          # echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
          #
          # See https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli for more.
          hashicorp:
            uri: https://apt.releases.hashicorp.com
            # If "architecture" is set to "auto", the value of the "ansible_facts['architecture']" mapping is used
            architecture: auto
            key_url: https://apt.releases.hashicorp.com/gpg
            # If "suite" is set to "auto", the value of "ansible_facts['distribution_release']" is used
            suite: auto
            components: main
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
