package main

import (
	"github.com/Sofassssssss/Board-game-tracking/internal/app"
	"github.com/Sofassssssss/Board-game-tracking/internal/http/validation"
)

func main() {
	validation.Init()
	application := app.NewApp()
	application.Run()
}
