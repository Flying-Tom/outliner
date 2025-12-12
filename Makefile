.PHONY: help clean get run run-macos test format analyze doctor build-macos build-windows build-linux

help:
	@echo "outliner - Makefile commands"
	@echo ""
	@echo "Development:"
	@echo "  make get           - Fetch dependencies (flutter pub get)"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make format        - Format Dart code"
	@echo "  make analyze       - Run static analysis (flutter analyze)"
	@echo "  make doctor        - Check Flutter environment setup"
	@echo ""
	@echo "Running:"
	@echo "  make run           - Run on default device"
	@echo "  make run-macos     - Run on macOS desktop"
	@echo ""
	@echo "Testing & Building:"
	@echo "  make test          - Run unit and widget tests"
	@echo "  make build-macos   - Build macOS desktop app"
	@echo "  make build-windows - Build Windows desktop app"
	@echo "  make build-linux   - Build Linux desktop app"
	@echo ""

# Dependency management
get:
	flutter pub get

clean:
	flutter clean
	rm -rf build/ .dart_tool/

# Code quality
format:
	dart format lib/ test/

analyze:
	flutter analyze

doctor:
	flutter doctor -v

# Running the app
run:
	flutter run

run-macos:
	flutter run -d macos

run-linux:
	flutter run -d linux

run-windows:
	flutter run -d windows

# Building
build-macos:
	flutter build macos

build-linux:
	flutter build linux

build-windows:
	flutter build windows

# Testing
test:
	flutter test


.DEFAULT_GOAL := help
