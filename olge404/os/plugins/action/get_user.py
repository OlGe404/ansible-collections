#!/usr/bin/env python3
"""Action plugin to find all non-system users based on the output of the 'getent passwd' command."""

from __future__ import (absolute_import, division, print_function)

from ansible.plugins.action import ActionBase
from ansible.module_utils.common.text.converters import to_text

__metaclass__ = type

DOCUMENTATION = """
  name: get_user
  author: https://github.com/OlGe404
  version_added: "0.9.0"
  description:
    - Get non-system user information based on "getent passwd" command output on remote host(s).
"""

EXAMPLES = """
  # Yes, this action plugin is called without providing parameters, this is not a typo.
  - name: Get get_user
    olge404.os.get_user: 
    register: get_user

  - name: Check returned data
    ansible.builtin.debug:
      var: get_user.users

  - name: Print all usernames
    ansible.builtin.debug:
      msg: "Username: {{ item.username }}"
    with_items: "{{ get_user.users }}"
"""

RETURN = """
  _raw:
    description:
      - List of user information.
      - > 
        Example output:
        users: [
          {'username': 'root', 'uid': 0, 'gid': 0, 'gecos': 'root', 'home': '/root', 'shell': /bin/bash'},
          {'username': 'user1', 'uid': 1000, 'gid': 1000, 'gecos': 'Debian', 'home': '/home/user1', 'shell': '/bin/sh'},
          {'username': 'user2', 'uid': 1001, 'gid': 1002, 'gecos': '', 'home': '/home/user2', 'shell': '/bin/bash'}
        ]
    type: list
"""


class ActionModule(ActionBase):
    """
    Class to hold action plugin methods. The 'run' method will be executed when the plugin is used
    in an ansible task.
    """

    def run(self, tmp=None, task_vars=None):
        # Run the "getent passwd" command on the remote host. We need to pass "tmp" and
        # "task_vars", even if they are 'None'.
        command = self._execute_module(module_name='ansible.builtin.command',
                                       module_args={'_raw_params': 'getent passwd'},
                                       tmp=tmp,
                                       task_vars=task_vars)

        command_stdout = to_text(command['stdout'], errors='surrogate_or_strict')

        # Passwd format: username:password:UID:GID:gecos(user description):home_dir:shell
        passwd_users: list[dict] = [{
            'username': line.split(':')[0],
            'uid': int(line.split(':')[2]),
            'gid': int(line.split(':')[3]),
            'gecos': line.split(':')[4],
            'home': line.split(':')[5],
            'shell': line.split(':')[6]
        } for line in command_stdout.split('\n')]

        # Vars to use as filter to find non-system users
        min_uid: int = 1000
        max_uid: int = 65535
        forbidden_shells: list = [
            '/bin/false',
            '/usr/sbin/nologin',
            '/sbin/nologin',
            '/sbin/shutdown',
            '/sbin/halt',
            '/bin/sync',
        ]

        users: list = [
            user for user in passwd_users if (user['uid'] == 0 or user['uid'] >= min_uid)
            and user['uid'] <= max_uid and user['shell'] not in forbidden_shells
        ]

        return {'users': users}
