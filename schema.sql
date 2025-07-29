-- Creating and connecting to the database
DROP DATABASE IF EXISTS gaming_leaderboard;
CREATE DATABASE gaming_leaderboard WITH ENCODING = 'UTF8';
\connect gaming_leaderboard

-- Tables of our gaming_leaderboard project
CREATE TABLE players (
  player_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  username VARCHAR(50) NOT NULL UNIQUE,
  registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  skill_rating INTEGER DEFAULT 1000
);

CREATE TABLE matches (
  match_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  game_type VARCHAR(30) NOT NULL,
  start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_time TIMESTAMP
);

CREATE TABLE match_results (
  match_id INTEGER REFERENCES matches(match_id) ON DELETE CASCADE ON UPDATE CASCADE,
  player_id INTEGER REFERENCES players(player_id) ON DELETE CASCADE ON UPDATE CASCADE,
  score INTEGER NOT NULL,
  PRIMARY KEY (match_id, player_id)
);