-- Query Anatomy: SELECT clause
SELECT CURRENT_TIMESTAMP;
SELECT version();
SELECT 2 + 2 AS simple_math;

-- Query Anatomy: FROM clause
SELECT * FROM players;

-- Column Selection - Data Projection
SELECT username, skill_rating 
FROM players;

-- Select specific columns
SELECT player_id, username FROM players;
-- Rename columns with aliases
SELECT username AS player_name, 
       skill_rating AS rating 
FROM players;
-- Perform calculations in SELECT
SELECT username,
       skill_rating - 1000 AS rating_above_baseline
FROM players;

-- Column aliases using AS keyword
SELECT 
    username AS player_name,
    skill_rating AS elo,
    registration_date AS joined
FROM players;

-- Using DISTINCT and DISTINCT ON
-- Find unique game types
SELECT DISTINCT game_type 
FROM matches;
-- Find unique game type and date combinations
SELECT DISTINCT game_type, 
                DATE(start_time)
FROM matches;
-- Get the most recent match for each game type
SELECT DISTINCT ON (game_type) 
       game_type, 
       DATE(start_time),
       DATE(end_time)
FROM matches

-- WHERE Clause fundamentals
SELECT username, skill_rating 
FROM players 
WHERE skill_rating > 1200;
-- Equal to
SELECT username FROM players WHERE skill_rating = 1000;
-- Not equal to
SELECT username FROM players WHERE skill_rating != 1000;
-- Less than or equal to
SELECT username FROM players WHERE skill_rating <= 1200;

-- Logical Operators
-- Using AND
SELECT username, registration_date 
FROM players 
WHERE skill_rating > 1000 
  AND registration_date >= CURRENT_DATE - INTERVAL '30 days';
-- Using OR
SELECT username 
FROM players 
WHERE skill_rating > 1500 
   OR registration_date = CURRENT_DATE;
-- Using NOT
SELECT username 
FROM players 
WHERE NOT skill_rating < 1000;

-- Pattern Matching (underscore)
SELECT username, skill_rating 
FROM players 
WHERE username LIKE 'Pro_Gamer99';

SELECT username, skill_rating 
FROM players 
WHERE username LIKE 'Pro_Game_99';
-- Escaped
SELECT username, skill_rating 
FROM players 
WHERE username LIKE 'Pro\_Game_99';

-- Pattern Matching (percentage)
-- Find usernames ending with 'Gamer'
SELECT username 
FROM players 
WHERE username LIKE '%Gamer';
-- Find usernames with 'Gamer' anywhere
SELECT username 
FROM players 
WHERE username LIKE '%Gamer%';
-- Find usernames with 'Gamer' anywhere in any case (ilike)
SELECT username 
FROM players 
WHERE username ILIKE '%gamer%';

-- NULL Value Handling
-- Find matches without end time (still in progress)
SELECT match_id, game_type 
FROM matches 
WHERE end_time IS NULL;
-- Find completed matches
SELECT match_id 
FROM matches 
WHERE end_time IS NOT NULL;
-- Not recommended way to find completed matches (but it works)
SELECT match_id 
FROM matches 
WHERE NOT end_time IS NULL;
-- Not recommended way to find matches completed less then a month ago
SELECT match_id, game_type
FROM matches 
WHERE NOT end_time > CURRENT_TIMESTAMP - INTERVAL '1 Month';
-- Use the right operator for that
SELECT match_id, game_type
FROM matches 
WHERE end_time <= CURRENT_TIMESTAMP - INTERVAL '1 Month';

-- IN and BETWEEN Operators
-- Range of ratings
SELECT username, skill_rating 
FROM players 
WHERE skill_rating BETWEEN 1000 AND 1500;
-- Specific game types
SELECT match_id 
FROM matches 
WHERE game_type IN ('Deathmatch', 'Capture Flag', 'Team Battle');
-- Inverted specific game types
SELECT match_id 
FROM matches 
WHERE game_type NOT IN ('Deathmatch', 'Capture Flag', 'Team Battle');

-- Result Control - ORDER BY
SELECT username, skill_rating
FROM players
ORDER BY skill_rating;
-- Highest ratings first
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC;
-- Lowest ratings first
SELECT username, skill_rating
FROM players
ORDER BY skill_rating ASC;
-- Multiple columns
SELECT username, skill_rating, registration_date
FROM players
ORDER BY skill_rating DESC, registration_date ASC;

-- NULLS LAST
SELECT match_id, end_time
FROM matches
ORDER BY end_time DESC NULLS LAST;

-- Ongoing matches (NULL end_time) first
SELECT match_id, end_time
FROM matches
ORDER BY end_time DESC NULLS FIRST;

-- LIMIT Clause
-- Get top 10 players by skill rating
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
LIMIT 10;

-- Skip first 10 players and get the next 10
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
OFFSET 10 LIMIT 10;

-- Get players ranked 21-30
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
OFFSET 20 LIMIT 10;

-- FETCH Clause
-- Get top 5 players by rating
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
FETCH FIRST 5 ROWS ONLY;
-- Using NEXT
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
FETCH NEXT 5 ROWS ONLY;
-- Skip first 10 players and get next 5
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
OFFSET 10 ROWS
FETCH FIRST 5 ROWS ONLY;
-- Get top 5 players, including ties
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
FETCH FIRST 5 ROWS WITH TIES;

-- Skip first 10 players and get next 5 (including ties)
SELECT username, skill_rating
FROM players
ORDER BY skill_rating DESC
OFFSET 10 ROWS
FETCH FIRST 5 ROWS WITH TIES;