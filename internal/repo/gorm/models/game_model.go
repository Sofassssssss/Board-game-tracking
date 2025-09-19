package models

type Game struct {
	ID          int    `gorm:"primaryKey;autoIncrement"`
	Title       string `gorm:"unique"`
	Description string
	IsTeamGame  bool
	/*
		To use enums we should run before migration
		db.Exec(`CREATE TYPE game_placement_policy AS ENUM ('forbidden', 'required')`)
		db.Exec(`CREATE TYPE game_score_policy AS ENUM ('forbidden', 'required', 'optional')`)
	*/
	PlacementPolicy     string `gorm:"type:game_placement_policy"`
	ScorePolicy         string `gorm:"type:game_score_policy"`
	ScoreHigherIsBetter *bool
	RatingUsesScore     *bool
	AllowDraws          bool
}
