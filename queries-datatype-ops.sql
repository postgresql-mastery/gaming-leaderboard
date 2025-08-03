-- String concatenation

-- Double Pipe
SELECT username, 'Skill Level: ' || skill_rating AS player_info
FROM players
LIMIT 5;
-- CONCAT function
SELECT username, 
  'Registered on: ' || registration_date AS registration_pipe,
  CONCAT('Registered on: ', registration_date) AS registration_concat
FROM players
ORDER BY registration_date NULLS FIRST;
-- Joining multiple values
SELECT CONCAT_WS(' - ', username, skill_rating, registration_date) AS player_summary
FROM players;

-- Essential functions
SELECT 
    username,
    LENGTH(username) AS name_length,
    UPPER(username) AS uppercase_name,
    LOWER(username) AS lowercase_name
FROM players;
-- Compare lowercased values
SELECT player_id, username 
FROM players 
WHERE LOWER(username) = 'shadowmaster';

-- Substring SQL standard
SELECT username,
  SUBSTRING(username FROM 3) AS from_third_char,
  SUBSTRING(username FOR 5) AS first_five_chars,
  SUBSTRING(username FROM 3 FOR 4) four_chars_in_the_middle
FROM players;
-- Imperative style
SELECT username,
  SUBSTRING(username, 3) AS from_third_char,
  SUBSTRING(username, 1, 5) AS first_five_chars,
  SUBSTRING(username, 3, 4) four_chars_in_the_middle
FROM players;
SELECT username,
  SUBSTR(username, 3) AS from_third_char,
  SUBSTR(username, 1, 5) AS first_five_chars,
  SUBSTR(username, 3, 4) four_chars_in_the_middle
FROM players;
-- Substr with lower/upper
SELECT username,
  UPPER(SUBSTRING(username, 1, 1)) || LOWER(SUBSTRING(username, 2))
  	AS proper_case
FROM players;

-- String trimming
SELECT
  -- Basic TRIM removes spaces from both ends
  TRIM('   PostgreSQL   ') AS both_ends_trimmed,
  -- LTRIM removes characters from the left (beginning)
  LTRIM('   PostgreSQL   ') AS left_trimmed,
  -- RTRIM removes characters from the right (end)
  RTRIM('   PostgreSQL   ') AS right_trimmed;
-- Better way
SELECT
  -- Remove underscores only from the beginning
  TRIM(LEADING '_' FROM '__PostgreSQL__') AS leading_only,
  -- Remove underscores only from the end
  TRIM(TRAILING '_' FROM '__PostgreSQL__') AS trailing_only,
  -- Remove underscores from both ends
  TRIM(BOTH '_' FROM '__PostgreSQL__') AS both_ends;
-- Real-world example: Cleaning usernames with unwanted spaces
UPDATE players
SET username = TRIM(username)
WHERE username LIKE ' %' OR username LIKE '% '
RETURNING player_id, username;

-- using replace
SELECT game_type,
  REPLACE(game_type, 'Team ', 'Group ') AS renamed_type
FROM matches
WHERE game_type LIKE 'Team%';


-- Regular Expressions
-- Tilde operator
SELECT username,
  REGEXP_REPLACE(username, '[0-9]+', 'X') AS numbers_replaced,
  (REGEXP_MATCHES(username, '[0-9]+'))[1] AS extracted_number,
  regexp_split_to_table(username, '[_A-Z]') AS word_component
FROM players
WHERE username ~ '[0-9]';

-- Mathematical functions
SELECT username, skill_rating,
  LOG(skill_rating) AS log_rating,
  EXP(skill_rating/1000) AS exp_rating,
  PI() * (skill_rating/1000) AS circle_area,
  SIN(RADIANS(45)) AS sine_value,
  ABS(1500 - skill_rating) AS rating_gap,
  POWER(skill_rating/1000, 2) AS squared_rating,
  SQRT(skill_rating) AS rating_root
FROM players
ORDER BY skill_rating DESC;

-- Random numbers
SELECT RANDOM() AS random_decimal,
  RANDOM() * 100 AS random_0_to_100,
  RANDOM() * 6 AS broken_dice_roll;

-- Rounding functions demonstration
SELECT match_id, score,
  ROUND(score/1000.0, 2) AS rounded_thousands,
  CEIL(score/1000.0) AS ceiling_thousands,
  FLOOR(score/1000.0) AS floor_thousands,
  TRUNC(score/1000.0, 1) AS truncated_thousands
FROM match_results;

-- Rounding and random
SELECT TRUNC(RANDOM()::NUMERIC, 4) AS trunc_random_decimal,
  ROUND(RANDOM()::NUMERIC * 100, 2) AS round_random_percentage,
  FLOOR(RANDOM() * 6) + 1 AS dice_roll;

-- Advanced calculations using player data
SELECT username, skill_rating,
  CASE 
    WHEN skill_rating > 1500 THEN 
      ROUND(POWER(skill_rating - 1500, 1.1) + skill_rating)
    WHEN skill_rating > 1000 THEN 
      ROUND(SQRT(skill_rating) * 10)
    ELSE skill_rating
    END AS calculated_score,
  GREATEST(skill_rating, 1200) AS minimum_rating,
  LEAST(skill_rating, 1800) AS capped_rating
FROM players;

-- Date/time handling

-- Extract month from registration dates
SELECT username, registration_date,
  EXTRACT(MONTH FROM registration_date) AS reg_month,
  DATE_PART('month', registration_date) AS reg_month_alt
FROM players
WHERE registration_date IS NOT NULL;

-- Count players registered per month
SELECT EXTRACT(YEAR FROM registration_date) AS reg_year,
  EXTRACT(MONTH FROM registration_date) AS reg_month,
  COUNT(*) AS new_players
FROM players
WHERE registration_date IS NOT NULL
GROUP BY reg_year, reg_month
ORDER BY reg_year, reg_month;

-- INTERVALs
SELECT CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP + INTERVAL '20 seconds' + '1 minute' as near_future,
  INTERVAL '1 month', INTERVAL '5 years',  
  INTERVAL '10', -- equivalent to: INTERVAL '10 seconds'
  INTERVAL '1000 milliseconds', -- equals to INTERVAL '1 second' is true
  INTERVAL '1000 microseconds', -- equals to INTERVAL '0.001 second' is true
  INTERVAL '1000 milliseconds' = INTERVAL '1 second',
  INTERVAL '1000 microseconds' = INTERVAL '0.001 second';

SELECT INTERVAL 10;  -- 👎 bad
SELECT INTERVAL '2 days' + 2; -- 👎 bad
SELECT INTERVAL '1 month' * 2; -- 👍 good
SELECT INTERVAL '1 month' + INTERVAL '1 month'; -- 👍 good
SELECT INTERVAL '100 hours' AS _100_hours,
  INTERVAL '360000 seconds' AS _360_000_seconds;

-- Extracting EPOCH
SELECT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP);
SELECT EXTRACT(EPOCH FROM INTERVAL '2 days 3 hours'),
  EXTRACT(EPOCH FROM INTERVAL '2 days'),
  EXTRACT(EPOCH FROM INTERVAL '3 hours');
SELECT 
  EXTRACT(EPOCH FROM INTERVAL '1 month') / 60 / 60 / 24 AS days_in_one_month,
  EXTRACT(EPOCH FROM INTERVAL '1 year') / 60 / 60 / 24 AS days_in_one_year,
  FLOOR(EXTRACT (EPOCH FROM INTERVAL '1 year') / 60 / 60 / 24) AS days_in_std_year;

-- Interval extractions with justifications
SELECT JUSTIFY_HOURS(INTERVAL '1000 hours') AS norm_days_in_1K_hours,
  JUSTIFY_DAYS(INTERVAL '5000 days') AS norm_months_in_5k_days,
  JUSTIFY_HOURS(INTERVAL '259200000 seconds') AS norm_days_in_259M_secs,
  JUSTIFY_DAYS(JUSTIFY_HOURS(INTERVAL '259200000 seconds')) AS norm_years_in_259M_secs;

SELECT JUSTIFY_INTERVAL(INTERVAL '1000 hours') AS just_days_in_1K_hours,
JUSTIFY_INTERVAL(INTERVAL '5000 days') AS just_months_in_5k_days,
JUSTIFY_INTERVAL(INTERVAL '259200060 seconds') AS just_days_in_259M_secs,
JUSTIFY_DAYS(JUSTIFY_HOURS(INTERVAL '259200060 seconds')) AS norm_years_in_259M_secs;

-- Date_trunc
SELECT DATE_TRUNC('year', CURRENT_TIMESTAMP) AS year_start,
  DATE_TRUNC('month', CURRENT_TIMESTAMP) AS month_start,
  DATE_TRUNC('day', CURRENT_TIMESTAMP) AS day_start,
  DATE_TRUNC('hour', CURRENT_TIMESTAMP) AS hour_start,
  CURRENT_TIMESTAMP AS exact_time;

-- Categorizing matches by time periods
SELECT match_id, game_type, start_time,
  DATE_TRUNC('day', start_time) AS match_day,
  DATE_TRUNC('hour', start_time) AS match_hour,
  DATE_TRUNC('week', start_time) AS match_week
FROM matches
ORDER BY start_time;

-- Finding period boundaries
SELECT 
  CURRENT_TIMESTAMP AS now,
  DATE_TRUNC('month', CURRENT_TIMESTAMP) AS month_start,
  DATE_TRUNC('month', CURRENT_TIMESTAMP) + INTERVAL '1 month' - INTERVAL '1 microsecond' AS month_end,
  DATE_TRUNC('year', CURRENT_TIMESTAMP) AS year_start,
  DATE_TRUNC('year', CURRENT_TIMESTAMP) + INTERVAL '1 year' - INTERVAL '1 day' AS year_end;

-- Find the next Sunday
SELECT CURRENT_DATE AS today,
  EXTRACT(DOW FROM CURRENT_DATE) AS day_of_week,
  CURRENT_DATE + ((7 - EXTRACT(DOW FROM CURRENT_DATE))::INTEGER % 7) AS next_sunday
  AT TIME ZONE;

-- Convert a timestamp to different time zones
SELECT start_time, -- this field is a TIMESTAMP (WITHOUT TIME ZONE)
    start_time AT TIME ZONE 'UTC' AS start_time_utc,
    start_time AT TIME ZONE 'America/Recife' AS start_time_rec,
    start_time AT TIME ZONE 'Australia/Sydney' AS start_time_syd
FROM matches;
-- Convert a timestamp to different time zones
SELECT start_time::TIMESTAMPTZ,
    start_time::TIMESTAMPTZ AT TIME ZONE 'UTC' AS start_time_utc,
    start_time::TIMESTAMPTZ AT TIME ZONE 'America/Recife' AS start_time_rec,
    start_time::TIMESTAMPTZ AT TIME ZONE 'Australia/Sydney' AS start_time_syd
FROM matches;

SELECT current_setting('TIMEZONE') AS my_session_timezone,
  TIMESTAMP WITH TIME ZONE '2025-04-14 12:00:00+00'
    AT TIME ZONE 'UTC' AS timetz_utc_to_utc,
  -- TIMESTAMPTZ is the same as TIMESTAMP WITH TIME ZONE
  TIMESTAMPTZ '2025-04-14 12:00:00+00'
    AT TIME ZONE current_setting('TIMEZONE') AS timetz_utc_to_current,
  -- TIMESTAMPTZ is the same as TIMESTAMP WITH TIME ZONE
  TIMESTAMPTZ '2025-04-14 12:00:00+10'
    AT TIME ZONE 'UTC' AS timetz_current_to_utc
  TIMESTAMP '2025-04-14 12:00:00'
    AT TIME ZONE current_setting('TIMEZONE') AS time_to_current,
  TIMESTAMP WITHOUT TIME ZONE '2025-04-14 12:00:00'
    AT TIME ZONE 'UTC' AS time_to_utc;

