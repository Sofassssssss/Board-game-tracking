DROP TRIGGER IF EXISTS match_player_before_insupd ON match_player;
DROP FUNCTION IF EXISTS trg_player_match_result_check();

DROP TRIGGER IF EXISTS player_ruleset_before_insupd ON player_ruleset;
DROP FUNCTION IF EXISTS trg_player_ruleset_check();

DROP TRIGGER IF EXISTS team_ruleset_before_insupd ON team_ruleset;
DROP FUNCTION IF EXISTS trg_team_ruleset_check();