.DEFAULT_GOAL := help

# VARIABLES
COMPOSE_DEV := docker-compose -f docker/compose.development.yaml
COMPOSE_PROD := docker-compose -f docker/compose.production.yaml
MODE ?= dev
ARGS ?= 
SERVICE ?= backend

# DOCKER SERVICES
.PHONY: up
up:
	@if [ "$(MODE)" = "prod" ]; then \
		$(COMPOSE_PROD) up -d $(ARGS); \
	else \
		$(COMPOSE_DEV) up -d $(ARGS); \
	fi

.PHONY: down
down:
	@if [ "$(MODE)" = "prod" ]; then \
		$(COMPOSE_PROD) down $(ARGS); \
	else \
		$(COMPOSE_DEV) down $(ARGS); \
	fi

.PHONY: build
build:
	@if [ "$(MODE)" = "prod" ]; then \
		$(COMPOSE_PROD) build $(ARGS); \
	else \
		$(COMPOSE_DEV) build $(ARGS); \
	fi

.PHONY: logs
logs:
	@if [ "$(MODE)" = "prod" ]; then \
		$(COMPOSE_PROD) logs -f $(SERVICE) $(ARGS); \
	else \
		$(COMPOSE_DEV) logs -f $(SERVICE) $(ARGS); \
	fi

.PHONY: restart
restart:
	@if [ "$(MODE)" = "prod" ]; then \
		$(COMPOSE_PROD) restart $(ARGS); \
	else \
		$(COMPOSE_DEV) restart $(ARGS); \
	fi

.PHONY: ps
ps:
	@if [ "$(MODE)" = "prod" ]; then \
		$(COMPOSE_PROD) ps $(ARGS); \
	else \
		$(COMPOSE_DEV) ps $(ARGS); \
	fi

.PHONY: shell
shell:
	@if [ "$(MODE)" = "prod" ]; then \
		$(COMPOSE_PROD) exec $(SERVICE) /bin/sh; \
	else \
		$(COMPOSE_DEV) exec $(SERVICE) /bin/sh; \
	fi


# CONVENIENCE ALIASES (DEVELOPMENT)
.PHONY: dev-up
dev-up: ## Alias: Start development environment
	@$(MAKE) up MODE=dev ARGS="--build"

.PHONY: dev-down
dev-down: ## Alias: Stop development environment
	@$(MAKE) down MODE=dev

.PHONY: dev-build
dev-build: ## Alias: Build development containers
	@$(MAKE) build MODE=dev

.PHONY: dev-logs
dev-logs: ## Alias: View development logs
	@$(MAKE) logs MODE=dev

.PHONY: dev-restart
dev-restart: ## Alias: Restart development services
	@$(MAKE) restart MODE=dev

.PHONY: dev-ps
dev-ps: ## Alias: Show running development containers
	@$(MAKE) ps MODE=dev

.PHONY: backend-shell
backend-shell: ## Alias: Open shell in backend container
	@$(MAKE) shell SERVICE=backend

.PHONY: gateway-shell
gateway-shell: ## Alias: Open shell in gateway container
	@$(MAKE) shell SERVICE=gateway

.PHONY: mongo-shell
mongo-shell: ## Open MongoDB shell
	@$(MAKE) shell SERVICE=mongo


# CONVENIENCE ALIASES (PRODUCTION)
.PHONY: prod-up
prod-up: ## Alias: Start production environment
	@$(MAKE) up MODE=prod ARGS="--build"

.PHONY: prod-down
prod-down: ## Alias: Stop production environment
	@$(MAKE) down MODE=prod

.PHONY: prod-build
prod-build: ## Alias: Build production containers
	@$(MAKE) build MODE=prod

.PHONY: prod-logs
prod-logs: ## Alias: View production logs
	@$(MAKE) logs MODE=prod

.PHONY: prod-restart
prod-restart: ## Alias: Restart production services
	@$(MAKE) restart MODE=prod


# CLEANUP
.PHONY: clean
clean: ## Remove containers and networks (both dev and prod)
	@$(MAKE) down MODE=dev ARGS="--volumes"
	@$(MAKE) down MODE=prod ARGS="--volumes"

.PHONY: clean-all
clean-all: clean ## Remove containers, networks, volumes, and images
	docker system prune -a -f --volumes

.PHONY: clean-volumes
clean-volumes: ## Remove all volumes
	docker volume prune -f


# HELP
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%%-20s\033[0m %%s\n", $$1, $$2}'