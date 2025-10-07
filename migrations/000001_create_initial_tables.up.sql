CREATE TYPE game_placement_policy AS ENUM ('forbidden', 'required');
CREATE TYPE game_score_policy AS ENUM ('forbidden', 'required', 'optional');
CREATE TYPE match_outcome AS ENUM ('win', 'loss', 'draw');
-- We may need to think about lookup tables for ENUMs in the future

CREATE TABLE role (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE club (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE club_role (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE game (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    is_team_game BOOLEAN NOT NULL,
    placement_policy game_placement_policy NOT NULL,
    score_policy game_score_policy NOT NULL,
    score_higher_is_better BOOLEAN,
    rating_uses_score BOOLEAN,
    allow_draws BOOLEAN NOT NULL
);

CREATE TABLE team_ruleset (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_id INT NOT NULL UNIQUE,
    min_teams INT NOT NULL,
    max_teams INT NOT NULL,
    min_players_per_team INT NOT NULL,
    max_players_per_team INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
);

CREATE TABLE player_ruleset (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_id INT NOT NULL UNIQUE,
    min_players INT NOT NULL,
    max_players INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
);

CREATE TABLE player (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    surname TEXT,
    club_id INT NOT NULL,
    FOREIGN KEY (club_id) REFERENCES club(id)
);

CREATE INDEX idx_players_club_id ON player (club_id);

CREATE TABLE account (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    hashed_password TEXT UNIQUE NOT NULL,
    email TEXT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role(id)
);

CREATE TABLE match (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_id INT NOT NULL,
    club_id INT NOT NULL,
    date DATE NOT NULL,
    created_by_account_id INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES game(id),
    FOREIGN KEY (club_id) REFERENCES club(id),
    FOREIGN KEY (created_by_account_id) REFERENCES account(id)
);

CREATE INDEX idx_matches_club_id ON match (club_id);

-- Relational tables

CREATE TABLE match_player (
    match_player_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    outcome match_outcome NOT NULL,
    placement INT,
    score NUMERIC,

    FOREIGN KEY (match_id) REFERENCES match(id),
    FOREIGN KEY (player_id) REFERENCES player(id)
);

CREATE INDEX idx_match_player_match_id ON match_player (match_id);
CREATE INDEX idx_match_player_player_id ON match_player (player_id);

CREATE TABLE account_club (
    account_club_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id INT NOT NULL,
    club_id INT NOT NULL,
    account_club_role_id INT NOT NULL,
    FOREIGN KEY (account_id) REFERENCES account(id),
    FOREIGN KEY (club_id) REFERENCES club(id),
    FOREIGN KEY (account_club_role_id) REFERENCES club_role(id)
);