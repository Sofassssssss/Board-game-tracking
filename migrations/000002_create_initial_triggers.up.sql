CREATE FUNCTION trg_team_rulesets_check() RETURNS trigger AS $$
DECLARE exists_other INT;
    DECLARE v_is_team_game BOOLEAN;
BEGIN
    -- Check if a player_ruleset already exists for the same game
    SELECT COUNT(*) INTO exists_other FROM player_rulesets WHERE game_id = NEW.game_id;
    IF exists_other > 0 THEN
        RAISE EXCEPTION 'player_ruleset already exists for game %', NEW.game_id;
    END IF;

    -- Check if the game is marked as a team game
    SELECT is_team_game INTO v_is_team_game FROM games WHERE id = NEW.game_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'game % not found', NEW.game_id;
    END IF;

    -- If the game is not a team game, raise an error
    IF NOT v_is_team_game THEN
        RAISE EXCEPTION 'games.is_team_game is false but inserting team_ruleset for game %', NEW.game_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER team_rulesets_before_insupd
    BEFORE INSERT OR UPDATE ON team_rulesets
    FOR EACH ROW EXECUTE FUNCTION trg_team_rulesets_check();

CREATE FUNCTION trg_player_rulesets_check() RETURNS trigger AS $$
DECLARE exists_other INT;
    DECLARE v_is_team_game BOOLEAN;
BEGIN

    -- Check if a team_ruleset already exists for the same game
    SELECT COUNT(*) INTO exists_other FROM team_rulesets WHERE game_id = NEW.game_id;
    IF exists_other > 0 THEN
        RAISE EXCEPTION 'team_ruleset already exists for game %', NEW.game_id;
    END IF;

    -- Check if the game is marked as a team game
    SELECT is_team_game INTO v_is_team_game FROM games WHERE id = NEW.game_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'game % not found', NEW.game_id;
    END IF;

    -- If the game is a team game, raise an error
    IF v_is_team_game THEN
        RAISE EXCEPTION 'games.is_team_game is true but inserting player_ruleset for game %', NEW.game_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER player_rulesets_before_insupd
    BEFORE INSERT OR UPDATE ON player_rulesets
    FOR EACH ROW EXECUTE FUNCTION trg_player_rulesets_check();

CREATE FUNCTION trg_player_match_results_check() RETURNS trigger AS $$
DECLARE v_allow_draws BOOLEAN;
    DECLARE v_score_policy game_score_policy;
    DECLARE v_placement_policy game_placement_policy;
    DECLARE v_game_id INT;
BEGIN

    IF TG_OP = 'UPDATE' AND
       OLD.outcome IS NOT DISTINCT FROM NEW.outcome AND
       OLD.score IS NOT DISTINCT FROM NEW.score AND
       OLD.placement IS NOT DISTINCT FROM NEW.placement THEN
        RETURN NEW;
    END IF;

    SELECT g.allow_draws, g.score_policy, g.placement_policy, m.game_id
    INTO v_allow_draws, v_score_policy, v_placement_policy, v_game_id
    FROM matches m
             JOIN games g ON m.game_id = g.id
    WHERE m.id = NEW.match_id;

    -- Outcome check
    IF NOT v_allow_draws AND NEW.outcome = 'draw' THEN
        RAISE EXCEPTION 'Draws are not allowed for match % (game_id %)', NEW.match_id, v_game_id;
    END IF;

    -- Score check
    IF v_score_policy = 'required' AND NEW.score IS NULL THEN
        RAISE EXCEPTION 'Score is required for match % (game_id %)', NEW.match_id, v_game_id;
    ELSIF v_score_policy = 'forbidden' AND NEW.score IS NOT NULL THEN
        RAISE EXCEPTION 'Score is not allowed for match % (game_id %)', NEW.match_id, v_game_id;
    END IF;

    -- Placement check
    IF v_placement_policy = 'forbidden' AND NEW.placement IS NOT NULL THEN
        RAISE EXCEPTION 'Placement is not allowed for match % (game_id %)', NEW.match_id, v_game_id;
    ELSIF v_placement_policy = 'required' AND NEW.placement IS NULL THEN
        RAISE EXCEPTION 'Placement is required for match % (game_id %)', NEW.match_id, v_game_id;
    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER matches_players_before_insupd
    BEFORE INSERT OR UPDATE ON matches_players
    FOR EACH ROW EXECUTE FUNCTION trg_player_match_results_check();