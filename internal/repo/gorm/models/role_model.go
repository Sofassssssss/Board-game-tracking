package models

type Role struct {
	ID    uint `gorm:"primaryKey;autoIncrement"`
	Name  string
	Users []User
}
