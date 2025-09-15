package models

import "gorm.io/gorm"

type Player struct {
	gorm.Model
	GroupID      uint
	Group        Group `gorm:"foreignKey:GroupID"`
	Name         string
	Surname      string
	MatchResults []MatchPlayer `gorm:"foreignKey:PlayerID"`
}
