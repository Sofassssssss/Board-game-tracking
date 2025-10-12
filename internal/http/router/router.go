package router

import (
	"github.com/Sofassssssss/Board-game-tracking/internal/http/handlers/auth"
	"github.com/Sofassssssss/Board-game-tracking/internal/http/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	r.POST("/signup", auth.Signup)
	r.POST("/login", auth.Login)
	r.GET("/validate", middleware.RequireAuth, auth.Validate)
}
