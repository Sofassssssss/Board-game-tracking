DROP TRIGGER IF EXISTS team_rulesets_before_insupd ON team_rulesets;
DROP FUNCTION IF EXISTS trg_team_rulesets_check();

DROP TRIGGER IF EXISTS player_rulesets_before_insupd ON player_rulesets;
DROP FUNCTION IF EXISTS trg_player_rulesets_check();

DROP TRIGGER IF EXISTS matches_players_before_insupd ON matches_players;
DROP FUNCTION IF EXISTS trg_player_match_results_check();