package models

type GroupRole struct {
	ID   int    `gorm:"primaryKey;autoIncrement"`
	Name string `gorm:"unique"`
}
