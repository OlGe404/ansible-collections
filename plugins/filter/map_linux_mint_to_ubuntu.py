"""
This filter plugin is used to map distribution codenames of Linux Mint releases
to codenames of corresponding Ubuntu releases. This enables the usage of `ansible_distribution`
as fact in roles like `apt` to add apt sources more easily and intuitively.
"""

def map_linux_mint_to_ubuntu(release):
    """
    This function returns the ubuntu codename for a given
    `ansible_distrubution_release` on a linux mint machine.
    """

    # See https://linuxmint.com/download_all.php
    mapping = {
        'wilma':    'noble',
        'virginia': 'jammy',
        'victoria': 'jammy',
        'vera':     'jammy',
        'vanessa':  'jammy'
    }

    return mapping.get(release, None)

class FilterModule(object):
    def filters(self):
        return {
            'map_linux_mint_to_ubuntu': map_linux_mint_to_ubuntu,
        }
