.PHONY: test unit-test integration-test install clean

# Default target
all: help

# Install the script
install:
	@echo "Installing ajv-geojson-shim..."
	@mkdir -p ~/.local/bin
	@cp bin/ajv-geojson-shim ~/.local/bin/
	@chmod +x ~/.local/bin/ajv-geojson-shim
	@echo "Installed to ~/.local/bin/ajv-geojson-shim"
	@echo "Make sure ~/.local/bin is in your PATH."
	@echo "To uninstall, run 'make uninstall'."
	@echo
	@make help

# Uninstall the script
uninstall:
	@echo "Uninstalling ajv-geojson-shim..."
	@rm -f ~/.local/bin/ajv-geojson-shim
	@echo "Uninstalled ajv-geojson-shim from ~/.local/bin"


# Run all tests
test: unit-test integration-test

# Run unit tests
unit-test:
	@chmod +x tests/test-unit.sh
	@./tests/test-unit.sh
	@echo

# Run integration tests
integration-test:
	@chmod +x tests/test-integration.sh
	@./tests/test-integration.sh
	@echo


# Show help
help:
	@echo "Available commands:"
	@echo "  make                  - List commands"
	@echo "  make help             - Show this help message"
	@echo "  make install          - Install script to ~/.local/bin"
	@echo "  make uninstall        - Uninstall script from ~/.local/bin"
	@echo "  make test             - Run all tests"
	@echo "  make unit-test        - Run unit tests only"
	@echo "  make integration-test - Run integration tests only"
