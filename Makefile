BIN_DIR=bin
BIN_NAME=myapp

build:
	mkdir -p $(BIN_DIR)
	go build -o $(BIN_DIR)/$(BIN_NAME) ./cmd/api
