.PHONY: install uninstall test test-shellcheck test-echint

SCRIPT = chkdm
TARGET_DIR = /usr/local/bin

ECHINT_TEST_MARKER = .echint.test-marker
SHELLCHECK_TEST_MARKER = .shellcheck.test-marker

install: | $(TARGET_DIR)
	cp $(SCRIPT) $(TARGET_DIR)/$(SCRIPT)
	@echo "Installed $(SCRIPT) to $(TARGET_DIR)"

uninstall:
	rm -f $(TARGET_DIR)/$(SCRIPT)
	@echo "Uninstalled $(SCRIPT) from $(TARGET_DIR)"

test-shellcheck: $(SHELLCHECK_TEST_MARKER)

test-echint: $(ECHINT_TEST_MARKER)

test: test-shellcheck test-echint
	@echo "Tests passed"

$(SHELLCHECK_TEST_MARKER): $(SCRIPT)
	shellcheck $(SCRIPT)
	@touch $(SHELLCHECK_TEST_MARKER)

$(ECHINT_TEST_MARKER): $(SCRIPT)
	echint $(SCRIPT)
	@touch $(ECHINT_TEST_MARKER)

$(TARGET_DIR):
	@mkdir -p $(TARGET_DIR)
