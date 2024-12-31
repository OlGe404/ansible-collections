#!/usr/bin/env python3

import yaml
import sys
import re

if __name__ == "__main__":
    with open('galaxy.yml', 'r') as file:
        data = yaml.safe_load(file)

    errors = []
    alphanumeric_pattern = re.compile(r'^[a-z0-9_]+$')
    semver_pattern = re.compile(r'^\d+\.\d+\.\d+$')
    
    # Validate 'namespace'
    if 'namespace' not in data or not alphanumeric_pattern.match(data['namespace']):
        errors.append(f"Invalid value for 'namespace': {data.get('namespace', 'MISSING')} (can only contain alphanumeric lowercase characters and underscores)")

    # Validate 'name'
    if 'name' not in data or not alphanumeric_pattern.match(data['name']):
        errors.append(f"Invalid value for 'name': {data.get('name', 'MISSING')} (can only contain alphanumeric lowercase characters and underscores)")

    # Valudate 'version'
    if 'version' not in data or not semver_pattern.match(data['version']):
        errors.append(f"Invalid value for 'version': {data.get('version', 'MISSING')} (has to be semver compatible, like '0.4.1')")

    # Validate 'tags'
    if 'tags' in data:
        for tag in data['tags']:
            if not alphanumeric_pattern.match(tag):
                errors.append(f"Invalid value in 'tags': {tag} (can only contain alphanumeric lowercase characters and underscores)")

    if errors:
        print("🚨 ERROR: Validation failed for 'galaxy.yml' file:")
        for error in errors:
            print(f"   - {error}")

        print("")
        sys.exit(1)

    print("✅ 'galaxy.yml' file is valid")
