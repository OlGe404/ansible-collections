# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [UNRELEASED]

### Added

- `homebrew` role

## [0.7.0] - 2025-01-02

### Added

- `pipx` role

## [0.6.1] - 2025-01-01

### Added

- checks if pip_packages values are provided to not alter the system if nothing has been set in `pip` role
- checks if pip_venv_dir already exists before creating it in `pip` role

### Fixed

- docs for `pip` role about venv handling

## [0.6.0] - 2024-12-31

### Added

- `pip` role

### Fixed

- "Role Name" in README of `yq` role

## [0.5.1] - 2024-12-31

### Added

- missing "Role Name" in README of `snap` role

### Changed

- descriptions and examples of dependencies, usage and specs in various roles

## [0.5.0] - 2024-12-31

### Added

- `snap` role

## [0.4.1] - 2024-12-30

### Changed

- descriptions of various roles to be more similar

### Fixed

- removed minor, superflous details from released roles

## [0.4.0] - 2024-12-26

### Added

- `docker_ce` role
- `yq` role
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
