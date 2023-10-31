olge404.os.install_argocd_cli
=========
Download and install the argocd cli tool.

Requirements
------------
Run these commands from the [root dir of the collection](../..) to install all requirements:

```bash
python3 -m pip install --upgrade --user -r requirements.txt
ansible-galaxy collection install -r requirements.yaml --force
```

Role Variables
--------------
Overview of the vars used in this role. See [Example Playbook usage](#Example-Playbook-usage) for more
details.

**_NOTE:_** See the [default vars](defaults/main.yml) before overwriting them in a playbook or otherwise.

| Name                       | Type   | Explanation                                                                                                                                                       |
| -------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| install_argocd_cli_version | String | Version of the argocd cli to install. See their [Github releases page](https://github.com/argoproj/argo-cd/releases/tag/v2.7.2) for a list of available versions. |

Dependencies
------------
None.

Example Playbook usage
----------------
```yaml
- name: Example 
  hosts: all
  roles:
    - role: olge404.os.install_argocd_cli
      vars:
        install_argocd_cli_version: v2.7.2
```

License
-------
Apache-2.0

Author Information
------------------
Created by https://github.com/OlGe404
