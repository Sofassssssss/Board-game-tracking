package migrations

import (
	gormrepo "github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm"
	"github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm/models"
)

func SyncDatabase() {
	gormrepo.DB.AutoMigrate(
		&models.Role{},
		&models.User{},
	)
}
