# flailsafe Makefile
# Install flailsafe into /opt/flailsafe

PREFIX        := /opt/flailsafe
BIN_DIR       := $(PREFIX)/bin
LIB_DIR       := $(PREFIX)/lib
VAR_DIR       := $(PREFIX)/var
VAULT_DIR     := $(VAR_DIR)/vault
LOG_DIR       := $(VAR_DIR)/log
DB_DIR        := $(VAR_DIR)/db

SYMLINK_BIN   := /usr/local/bin/flailsafe

.PHONY: install uninstall

install:
	@echo "Installing flailsafe to $(PREFIX)"

	# Create directory structure
	mkdir -p $(BIN_DIR)
	mkdir -p $(LIB_DIR)
	mkdir -p $(VAULT_DIR)
	mkdir -p $(LOG_DIR)
	mkdir -p $(DB_DIR)

	# Install main executable
	install -m 755 bin/flailsafe $(BIN_DIR)/flailsafe

	# Install libraries
	cp -r lib/* $(LIB_DIR)/

	# Create empty DB and log files if missing
	touch $(DB_DIR)/files.db
	touch $(LOG_DIR)/flailsafe.log

	# Set secure permissions
	chmod 600 $(DB_DIR)/files.db
	chmod 600 $(LOG_DIR)/flailsafe.log

	# Create symlink
	ln -sf $(BIN_DIR)/flailsafe $(SYMLINK_BIN)

	@echo "Installation complete."
	@echo "Run with: sudo flailsafe help"

uninstall:
	@echo "Uninstalling flailsafe"

	# Remove installation directory
	rm -rf $(PREFIX)

	# Remove symlink
	rm -f $(SYMLINK_BIN)

	@echo "flailsafe has been removed."

