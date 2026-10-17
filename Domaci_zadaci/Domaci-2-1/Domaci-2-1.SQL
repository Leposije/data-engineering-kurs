
-- 1. Zadatak
SELECT match_id, season, kickoff_ts, home_team, away_team, stadium_name,
       stadium_capacity, attendance,
       stadium_capacity - attendance AS empty_seats
FROM matches_flat
ORDER BY empty_seats DESC
LIMIT 5;

-- Zajednicko je da je domacin Oakfield Town i da se igralo na stadionu National Stadium gde je kapacitet 80 000



-- 2. Zadatak
SELECT COUNT(DISTINCT referee_name) AS broj_sudija
FROM matches_flat
WHERE home_team = 'Riverton Athletic';

-- 15 sudija

-- 3. Zadatak
SELECT COUNT(*) AS broj_utakmica
FROM matches_flat
WHERE away_goals_ht > home_goals_ht AND home_goals > away_goals;

-- Ukupno 15 utakmica gde je gost vodio na poluvremenu, a na kraju pobedio domacin 

-- 4. Zadatak
SELECT match_id, kickoff_ts, home_team, away_team,
       home_goals_ht, away_goals_ht,
       home_goals, away_goals,
       (home_goals - home_goals_ht) + (away_goals - away_goals_ht) AS second_half_goals
FROM matches_flat
ORDER BY second_half_goals DESC
LIMIT 1;


-- Utakmica Northport United  Newbury Forest, na poluvreme je bilo 1:0, a na kraju 6:3


-- 5. Zadatak
SELECT COUNT(*) AS broj_utakmica
FROM matches_flat
WHERE season = '2023/24'
  AND weather IN ('snow', 'fog');

-- 6. Zadatak
SELECT 
    kickoff_ts, season, home_team, away_team,
    home_goals, away_goals, stadium_name
FROM matches_flat
WHERE (home_team = 'Northport United' OR away_team = 'Northport United') AND (home_team = 'Northport City' OR away_team = 'Northport City')
ORDER BY kickoff_ts;

--2023/2024	Pobednik Northport United
--2024/2025 Ruzltat je bio nereseno, nema povednika
--2024/2025	Pobednik Northport City
--2025/2026	Pobednik Northport United

-- 7. Zadatak
SELECT match_id, kickoff_ts, home_team, away_team
FROM matches_flat
WHERE season = '2024/25'
ORDER BY kickoff_ts, match_id
LIMIT 3;

--  Ne mozemo biti sigurnu koja ce biti druga ili treba po vremene,  pa smo stavili match_id kao tiebreaker



-- 8. Zadatak
SELECT match_id, kickoff_ts, home_team, away_team, first_goal_minute, first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer = "Sean O'Neill"
ORDER BY kickoff_ts;
-- prikaz

SELECT COUNT(*) AS broj_utakmica
FROM matches_flat
WHERE first_goal_scorer = "Sean O'Neill";

--  Na ukupno 2 utakmice je Sean O'Neill dao prvi gol 