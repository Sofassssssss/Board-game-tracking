package gormrepo

import (
	"github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm/models"
	"gorm.io/gorm"
)

func SeedRoles(db *gorm.DB) {
	roles := []models.Role{
		{Name: "admin"},
		{Name: "ordinary_user"},
	}

	for _, role := range roles {
		db.FirstOrCreate(&role, models.Role{Name: role.Name})
	}
}
