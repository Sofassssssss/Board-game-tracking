package app

import (
	"log"

	"github.com/Sofassssssss/Board-game-tracking/internal/config"
	"github.com/Sofassssssss/Board-game-tracking/internal/http/router"
	"github.com/Sofassssssss/Board-game-tracking/internal/http/validation"
	gormrepo "github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm"
	"github.com/Sofassssssss/Board-game-tracking/migrations"
	"github.com/gin-gonic/gin"
)

type App struct {
	Router *gin.Engine
}

func NewApp() *App {
	// init config
	config.LoadEnvVariables()

	// init DB
	gormrepo.ConnectToDb()

	// migrations + seed
	migrations.SyncDatabase()
	gormrepo.SeedRoles(gormrepo.DB)

	// init router
	r := gin.Default()
	router.SetupRoutes(r)

	validation.Init()

	return &App{Router: r}
}

func (a *App) Run() {
	err := a.Router.Run()
	if err != nil {
		log.Fatal("Unable to start router")
	}
}
