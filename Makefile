# Variables
SHELL := /bin/bash

.PHONY: all clean help buildsite

all: ## Default target
	@echo "No default target specified. Use 'make help' to see available commands."

clean: ## Remove build artifacts
	@echo "Cleaning up..."
	@rm -rf build dist *.pyc *.o

buildsite: ## Build the site using buildsite.py
	poetry run ./software/util/buildsite.py -a

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' 