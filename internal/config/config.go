package config

import (
	"log"
	"time"

	"github.com/joho/godotenv"
)

const (
	TokenMaxAge = 30 * 24 * time.Hour // 30 days
)

func LoadEnvVariables() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}
