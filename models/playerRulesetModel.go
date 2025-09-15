package models

type PlayerRuleset struct {
	ID         int `gorm:"primaryKey;autoIncrement"`
	GameID     uint
	Game       Game `gorm:"foreignKey:GameID"`
	MinPlayers int
	MaxPlayers int
}
