# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2024-12-26

### Added

- `docker_ce` role
- docs in `README.md` on how to use vagrant as test platform driver, when containers are not sufficient

### Removed

- Dockerfiles/refs/galaxy tags for almalinux/RHEL. It is not supported because I don't have a use case at the moment
- join() expressions in task names in `apt` and `vscode_extensions` roles

## [0.3.1] - 2024-12-24

### Fixed

- execution failure when `packages` fact is not/cannot be defined in `apt` role

### Added

- vscode marketplace example in README of `vscode_extensions` role

### Fixed

- typos in README of `vscode_extensions` role
- typos in README of `tuxedo_tomte` role

## [0.3.0] - 2024-12-24

### Added

- `vscode_extensions` role
- Link to tuxedo-tomte docs in `tuxedo_tomte` role

## [0.2.0] - 2024-12-24

### Added

- `ppa:git-core/ppa` to apt_repos examples in README.md of `apt` role
- `tuxedo_tomte`role

### Removed

- Dockerfile, refs etc. for 'alpine' support. When you think about it: ansible would be a poor choice
  to manage alpine installations (as you would manage any other distro with ansible) because of the python overhead
  that ansible comes with + not all ansible modules are compatible with alpine

## [0.1.1] - 2024-12-23

### Fixed

- File refs in README.md for scripts, changelog.md etc. so refs work when docs are viewed on galaxy hub
- Formatting in README.md of lists

## [0.1.0] - 2024-12-23

### Added

- Initial release
