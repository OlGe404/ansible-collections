.SILENT: molecule

ROLES_DIR := "$(shell git rev-parse --show-toplevel)/olge404/os/roles"
SHARED := "$(shell git rev-parse --show-toplevel)/olge404/os/shared"

ROLES ?= $(shell ls $(ROLES_DIR))
SEQUENCE ?= "test"

molecule:
	for role in $(ROLES); do \
		cd $(ROLES_DIR)/$$role && \
		if [ -d "molecule" ]; then \
			molecule --base-config $(SHARED)/molecule.yml $(SEQUENCE); \
		fi \
	done
