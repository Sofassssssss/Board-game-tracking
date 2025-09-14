package models

import "gorm.io/gorm"

type Match struct {
	gorm.Model
	GameID          uint
	Game            Game `gorm:"foreignKey:GameID"`
	GroupID         uint
	Group           Group `gorm:"foreignKey:GroupID"`
	CreatedByUserID uint
	CreatedByUser   User          `gorm:"foreignKey:CreatedByUserID"`
	Players         []MatchPlayer `gorm:"foreignKey:MatchID"`
}
