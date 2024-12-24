apt
=========

Install apt packages on debian-like linux distros (ubuntu, linuxmint, pop!_os, etc.) from built-in or external apt sources.

Requirements
------------

On the control node:

* [Requirements for the ansible.builtin.apt module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html#requirements)


On the target node:

* sudo privileges

Role Variables
--------------

All vars have empty default values set. If you don't provide any values for them, the tasks that use these vars won't have any effect on your system.

> **NOTE**: You will only need (or want) to use the `apt_packages_overwrite` or `apt_repos_overwrite` vars when using configuration layering with `group_vars` and `host_vars`. If this is not your use-case, you can simply (and safely) ignore them.

 See the [Example Playbook](#example-playbook) section for more.

| Name                   | Type | Default | Description                                                                                |
| ---------------------- | ---- | ------- | ------------------------------------------------------------------------------------------ |
| apt_packages           | dict | {}      | Key/value pairs of apt packages to install in the format of `packageName: packageVersion`. |
| apt_packages_overwrite | dict | {}      | Key/value pairs of packages to overwrite `apt_packages` var entries with in the format of `packageName: packageVersion`. This can be used to add additional packages/set a different version for a package on a specific host when layering configuration using `group_vars` and `host_vars`. |
| apt_repos              | dict | {}      | Key/value pairs of apt repos to add. See the [Example Playbook](#example-playbook) section for more. |
| apt_repos_overwrite    | dict | {}      | Key/value pairs of apt repos to overwrite `apt_repos` var entries with. This can be used to overwrite existing/add additional repos on a specific host when layering configuration using `group_vars` and `host_vars`. |

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

        # Dict of packages that are merged with "apt_packages" var. If identical keys exist, values from key in "apt_packages_overwrite" take precedence.
        # 
        # In this example, version "2.50.0" of the "gh" package will be installed (instead of version "2.43.0").
        # This is useful if you are layering configuration using group_vars and host_vars and want to overwrite specific
        # package versions on specific hosts. It can also be used to add more packages on a specific host (and not just to overwrite existing ones).
        apt_packages_overwrite:
          gh: "2.50.0"

        # Dict of apt repos to add. Sources will be added and refreshed before package installations.
        apt_repos:
          github:
            # Source string of the repo that can typically be found in the installation docs for a software package,
            # e.g. https://github.com/cli/cli/blob/trunk/docs/install_linux.md
            source: "deb [arch=amd64 signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"
            key:
              # URL to download the key from. The "ansible.builtin.get_url" module is used to download the key.
              download_url: https://cli.github.com/packages/githubcli-archive-keyring.gpg
              # The "save_to" path has to match the "signed-by" path in "source" to ensure the downloaded key is used properly.
              save_to: /etc/apt/keyrings/githubcli-archive-keyring.gpg
              # You don't need to dearmor the keys, if the installation docs for your software package don't mention it.
              dearmor: false

          hashicorp:
            # Some sources use shell expressions like "$(lsb_release -cs)" in their scripts.
            # You have to replace those with the corresponding ansible fact or plaintext value, because shell expressions aren't evaluated
            # when adding sources.
            #
            # In this example, "$(lsb_release -cs)" was replaced with "{{ ansible_distribution_release }}".
            source: "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com {{ ansible_distribution_release }} main"
            key:
              download_url: https://apt.releases.hashicorp.com/gpg
              save_to: /usr/share/keyrings/hashicorp-archive-keyring.gpg
              # You need to dearmor a GPG key for an APT source if the key is provided in ASCII-armored format
              # (typically beginning with "-----BEGIN PGP PUBLIC KEY BLOCK-----").
              dearmor: true
          
          postgresql:
            source: "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt {{ ansible_distribution_release }}-pgdg main"
            key:
              download_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
              # Armored keys that use a ".asc" extension are dearmored automatically, so "dearmor: false" has to be set.
              save_to: /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
              dearmor: false
      
        # Dict of repos that are merged with "apt_repos" var. If identical keys exist, values from key in "apt_repos_overwrite" take precedence.
        # This is useful if you are layering configuration using group_vars and host_vars and want to overwrite specific values on specific hosts,
        # e.g. to change sources to test package installations after upgrading the OS.
        # It can also be used to add more apt_repos on a specific host (and not just to overwrite existing ones).
        apt_repos_overwrite:
          # Add the "kubernetes" repo in addition to the repos which are part of "apt_repos" var.
          kubernetes:
            source: "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /"
            key:
              download_url: https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key
              save_to: /etc/apt/keyrings/kubernetes-apt-keyring.gpg
              dearmor: true
          
          # You can add sources without having to specify the "key" section, if no key is required to add the repository
          # (can be done with "deb" sources, too).
          git:
            source: ppa:git-core/ppa
```

License
-------

Apache License 2.0 (https://apache.org/licenses/LICENSE-2.0#apache-license-version-20)

Author Information
------------------

Written and maintained by [OlGe404](https://github.com/OlGe404).
