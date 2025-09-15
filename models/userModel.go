package models

import "gorm.io/gorm"

type User struct {
	gorm.Model
	RoleID         uint
	Role           Role   `gorm:"foreignKey:RoleID"`
	Username       string `gorm:"unique"`
	HashedPassword string
	Email          string `gorm:"unique"`
}
