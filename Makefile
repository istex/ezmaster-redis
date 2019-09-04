.PHONY: help build

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## build the docker istex/ezmaster-redis:latest image locally
	@docker build -t istex/ezmaster-redis:latest --build-arg http_proxy --build-arg https_proxy .

