BIN_DIR=bin
BIN_NAME=myapp

MIGRATIONS_DIR ?= migrations
MIGRATE ?= migrate

# Load environment variables from .env file if it exists
ifneq (,$(wildcard .env))
	include .env
	export
endif

DB_URL ?= postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(DB_SSLMODE)&timezone=$(DB_TIMEZONE)

.PHONY: build migrate-up migrate-down ensure-migrations migrate-new dump-db-url migrate-step

# build the Go application
build:
	mkdir -p $(BIN_DIR)
	go build -o $(BIN_DIR)/$(BIN_NAME) ./cmd/api

# print the current database URL
dump-db-url:
	@echo "DB_URL=$(DB_URL)"

# apply all up migrations
migrate-up:
	$(MIGRATE) -path $(MIGRATIONS_DIR) -database "$(DB_URL)" up

# revert all migrations (dangerous)
migrate-down:
	$(MIGRATE) -path $(MIGRATIONS_DIR) -database "$(DB_URL)" down

# revert n migrations
migrate-step:
	@if [ -z "$(n)" ]; then \
		echo "Usage: make migrate-step n=N"; exit 1; \
	fi
	$(MIGRATE) -path $(MIGRATIONS_DIR) -database "$(DB_URL)" down $(n)

# show current migration version
migrate-version:
	$(MIGRATE) -path $(MIGRATIONS_DIR) -database "$(DB_URL)" version

# ensure migrations directory exists
ensure-migrations:
	@[ -d "$(MIGRATIONS_DIR)" ] || mkdir -p $(MIGRATIONS_DIR)

# create a new migration file with a given name
migrate-new: ensure-migrations
	@if [ -z "$(name)" ]; then \
		echo "Usage: make migrate-new name=your_description"; exit 1; \
	fi
	@echo "Creating migration '$(name)' in $(MIGRATIONS_DIR)..."
	$(MIGRATE) create -ext sql -dir $(MIGRATIONS_DIR) -seq $(name)
	@echo "Migrations created successfully."