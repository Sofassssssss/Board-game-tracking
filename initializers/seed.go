package initializers

import (
	"github.com/Sofassssssss/Board-game-tracking/models"
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
