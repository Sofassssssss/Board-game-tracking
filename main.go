package main

import (
	"github.com/Sofassssssss/Board-game-tracking/controllers"
	"github.com/Sofassssssss/Board-game-tracking/initializers"
	"github.com/Sofassssssss/Board-game-tracking/middleware"
	"github.com/gin-gonic/gin"
)

func init() {
	initializers.LoadEnvVariables()
	initializers.ConnectToDb()
	initializers.SyncDatabase()

	initializers.SeedRoles(initializers.DB)
}

func main() {
	router := gin.Default()
	router.POST("/signup", controllers.Signup)
	router.POST("/login", controllers.Login)
	router.GET("/validate", middleware.RequireAuth, controllers.Validate)

	router.Run()
}
