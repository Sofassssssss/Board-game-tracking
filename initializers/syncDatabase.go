package initializers

import "github.com/Sofassssssss/Board-game-tracking/models"

func SyncDatabase() {
	DB.AutoMigrate(
		&models.Role{},
		&models.User{},
	)
}
