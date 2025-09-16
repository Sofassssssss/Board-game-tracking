package models

type TeamRuleset struct {
	ID                int `gorm:"primaryKey;autoIncrement"`
	GameID            uint
	Game              Game `gorm:"foreignKey:GameID"`
	MinTeams          int
	MaxTeams          int
	MinPlayersPerTeam int
	MaxPlayersPerTeam int
}
