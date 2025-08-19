package models

type MatchPlayer struct {
	MatchPlayerID int `gorm:"primaryKey;autoIncrement"`
	MatchID       uint
	Match         Match `gorm:"foreignKey:MatchID"`
	PlayerID      uint
	Player        Player `gorm:"foreignKey:PlayerID"`
	Outcome       string
	Placement     *int
	Score         *float64
}
