INSERT INTO players (username, registration_date, skill_rating) VALUES
('ShadowMaster', CURRENT_TIMESTAMP - INTERVAL '1 year, 3 months, 4 hours', 1450),
('PixelQueen', CURRENT_TIMESTAMP - INTERVAL '1 year, 2 months', 1320),
('DragonSlayer42', CURRENT_TIMESTAMP - INTERVAL '1 year, 1 month', 1550),
('NeonBlade', CURRENT_TIMESTAMP - INTERVAL '1 year', 1220),
('MysticGamer', CURRENT_TIMESTAMP - INTERVAL '1 year, 6 months, 12 hours', 1675),
('CyberViking', CURRENT_TIMESTAMP - INTERVAL '1 year, 10 days, 4 hours', 1000),
('StealthNinja', NULL, 1425), -- For NULL registration_date example
('AzureKnight', CURRENT_TIMESTAMP - INTERVAL '1 year, 1 month, 12 hours', 1300);

INSERT INTO matches (game_type, start_time, end_time) VALUES
('Team Deathmatch', CURRENT_TIMESTAMP - INTERVAL '10 months, 30 minutes', CURRENT_TIMESTAMP - INTERVAL '10 months'),
('Capture Flag', CURRENT_TIMESTAMP - INTERVAL '9 months, 35 minutes', CURRENT_TIMESTAMP - INTERVAL '9 months'),
('Team Deathmatch', CURRENT_TIMESTAMP - INTERVAL '8 months, 30 minutes', CURRENT_TIMESTAMP - INTERVAL '8 months'),
('Zombie Survival', CURRENT_TIMESTAMP - INTERVAL '7 months, 3 days, 10 minutes', CURRENT_TIMESTAMP - INTERVAL '7 months, 3 days');

INSERT INTO match_results (match_id, player_id, score) VALUES
(1, 1, 4500), (1, 2, 3800), (1, 5, 4200),
(2, 3, 7200), (2, 4, 6500),
(3, 1, 4800), (3, 3, 5100),
(4, 2, 8900), (4, 5, 9200);

-- Special data for specific demonstrations
INSERT INTO players (username, skill_rating) VALUES
('Pro_Gamer99', 2100), -- For high-skill examples
('NovicePlayer', 850), -- Below 1000 rating
('Case_Study', 1500); -- For CASE expression examples

INSERT INTO matches (game_type, start_time, end_time) VALUES
('Historical Battle', CURRENT_TIMESTAMP - INTERVAL '2 days, 4 hours', CURRENT_TIMESTAMP - INTERVAL '2 days, 3 hours'),
('Historical Battle', CURRENT_TIMESTAMP - INTERVAL '2 days, 3 hours, 30 minutes', CURRENT_TIMESTAMP - INTERVAL '2 days, 1 hour'),
('Solo Battle', CURRENT_TIMESTAMP - INTERVAL '1 day', NULL); -- Ongoing match

INSERT INTO match_results (match_id, player_id, score) VALUES
(5, 9, 10000), (6, 9, 9500),
(7, 6, 1500); -- Partial score for ongoing match

-- Locking example data
INSERT INTO players (username, skill_rating) VALUES
('LockTestPlayer', 1600);