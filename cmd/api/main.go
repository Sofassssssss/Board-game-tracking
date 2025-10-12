package main

import (
	"github.com/Sofassssssss/Board-game-tracking/internal/app"
	"github.com/Sofassssssss/Board-game-tracking/internal/http/validators"
)

func main() {
	validators.Init()
	application := app.NewApp()
	application.Run()
}
