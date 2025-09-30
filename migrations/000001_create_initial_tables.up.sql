CREATE TYPE game_placement_policy AS ENUM ('forbidden', 'required');
CREATE TYPE game_score_policy AS ENUM ('forbidden', 'required', 'optional');
CREATE TYPE match_outcome AS ENUM ('win', 'loss', 'draw');
-- We may need to think about lookup tables for ENUMs in the future

CREATE TABLE roles (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE groups (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE group_roles (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE games (
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

CREATE TABLE team_rulesets (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_id INT NOT NULL UNIQUE,
    min_teams INT NOT NULL,
    max_teams INT NOT NULL,
    min_players_per_team INT NOT NULL,
    max_players_per_team INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE TABLE player_rulesets (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_id INT NOT NULL UNIQUE,
    min_players INT NOT NULL,
    max_players INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE TABLE players (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    surname TEXT,
    group_id INT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES groups(id)
);

CREATE INDEX idx_players_group_id ON players (group_id);

CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    hashed_password TEXT UNIQUE NOT NULL,
    email TEXT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE matches (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_id INT NOT NULL,
    group_id INT NOT NULL,
    created_by_user_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(id),
    FOREIGN KEY (group_id) REFERENCES groups(id),
    FOREIGN KEY (created_by_user_id) REFERENCES users(id)
);

CREATE INDEX idx_matches_group_id ON matches (group_id);

-- Relational tables

CREATE TABLE matches_players (
    match_player_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    outcome match_outcome NOT NULL,
    placement INT,
    score NUMERIC,

    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (player_id) REFERENCES players(id)
);

CREATE INDEX idx_matches_players_match_id ON matches_players (match_id);
CREATE INDEX idx_matches_players_player_id ON matches_players (player_id);

CREATE TABLE users_groups (
    user_group_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    group_id INT NOT NULL,
    user_group_role_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (group_id) REFERENCES groups(id),
    FOREIGN KEY (user_group_role_id) REFERENCES group_roles(id)
);