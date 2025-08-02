-- PostgreSQL variables through
SELECT current_setting('search_path') search_path,
  current_setting('server_version') server_version,
  current_setting('timezone') timezone;

-- Find information about string functions
SELECT 
    proname AS function_name, 
    prosrc AS source,
    pg_get_function_arguments(oid) AS arguments
FROM pg_proc 
WHERE proname LIKE '%string%'
AND prokind = 'f'
ORDER BY proname;

-- View all configuration settings
SELECT name, setting, category, short_desc
FROM pg_settings
ORDER BY category, name;
-- Search for specific settings
SELECT name, setting, short_desc
FROM pg_settings
WHERE name LIKE '%timeout%'
ORDER BY name;

-- Session functions
SELECT current_user, session_user, current_database(), current_schema;

-- Connection functions
SELECT inet_client_addr(), inet_client_port(),
  inet_server_addr(), inet_server_port();
-- connection details for sensitive operations
INSERT INTO audit_log (
  operation, user_name, client_ip, 
  client_port, operation_time
) VALUES (
  'data_export', current_user, inet_client_addr(),
  inet_client_port(),current_timestamp
);

-- Case statements

-- Basic Structure and Evaluation Process
SELECT username, skill_rating,
	CASE skill_rating
		WHEN 2100 THEN 'Grandmaster'
		WHEN 1500 THEN 'Expert'
		WHEN 850 THEN 'Beginner'
	END as player_rank,
	CURRENT_DATE as ranking_as_of
FROM players

-- Search case structure
SELECT username, skill_rating,
    CASE 
        WHEN skill_rating >= 1600 THEN 'Grandmaster'
        WHEN skill_rating >= 1400 THEN 'Expert'
        WHEN skill_rating >= 1200 THEN 'Skilled'
        WHEN skill_rating >= 1000 THEN 'Average'
        ELSE 'Beginner'
    END AS player_tier
FROM players ORDER BY skill_rating DESC;

-- More complex CASE
SELECT username, registration_date, skill_rating,
  CASE 
    WHEN registration_date IS NULL THEN 'Unknown'
    WHEN registration_date > '2024-03-01' AND skill_rating > 1300 THEN 'New Star'
    WHEN registration_date > '2024-03-01' THEN 'Promising Rookie'
    WHEN skill_rating > 1500 THEN 'Seasoned Veteran'
    ELSE 'Regular Player'
  END AS player_status
FROM players ORDER BY player_status, username;

-- Dynamic player categorization
SELECT username, registration_date, skill_rating,
  CASE 
    WHEN registration_date IS NULL THEN 'Unknown'
    WHEN registration_date > (CURRENT_DATE - INTERVAL '30 days') AND skill_rating > 1300 THEN 'Rising Star'
    WHEN registration_date > (CURRENT_DATE - INTERVAL '30 days') THEN 'New Player'
    WHEN registration_date > (CURRENT_DATE - INTERVAL '90 days') THEN 'Recent Player'
    WHEN skill_rating > 1500 THEN 'Seasoned Veteran'
    ELSE 'Regular Player'
  END AS player_status
FROM players ORDER BY registration_date DESC NULLS LAST;

-- data transformation
SELECT match_id, game_type,
  CASE 
    WHEN game_type ILIKE '%team%' THEN 'Team-based'
    WHEN game_type LIKE 'Solo%' THEN 'Individual'
    WHEN game_type ILIKE '%survival' THEN 'Cooperative'
    ELSE 'Other'
  END AS match_category, start_time, end_time
FROM matches;

-- Custom Sorting
SELECT username, skill_rating,
  CASE WHEN skill_rating >= 1800 THEN 'Pro League'
    WHEN skill_rating >= 1400 THEN 'Gold Tier'
    WHEN skill_rating >= 1100 THEN 'Silver Tier'
    ELSE 'Bronze Tier'
  END AS player_league
FROM players ORDER BY CASE 
  WHEN skill_rating >= 1800 THEN 1  -- Pro League players first
  WHEN skill_rating >= 1400 THEN 2  -- Gold Tier players second
  WHEN skill_rating >= 1100 THEN 3  -- Silver Tier players third
  ELSE 4                            -- Bronze Tier players last
END, random();
