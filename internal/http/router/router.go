package router

import (
	"github.com/Sofassssssss/Board-game-tracking/internal/http/handlers"
	"github.com/Sofassssssss/Board-game-tracking/internal/http/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	r.POST("/signup", handlers.Signup)
	r.POST("/login", handlers.Login)
	r.GET("/validate", middleware.RequireAuth, handlers.Validate)
}
