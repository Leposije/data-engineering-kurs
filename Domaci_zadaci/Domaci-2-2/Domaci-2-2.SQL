
-- 1.Zadatak
SELECT match_id, kickoff_ts, home_team, away_team, match_report
FROM matches_flat
WHERE match_report ILIKE '%goal%'
ORDER BY kickoff_ts, match_id;

-- Prikazuje se 41 broj utakmica, u match report za svaku pise Goalless stalemate

-- 2.Zadatak
SELECT match_id, kickoff_ts, home_team, away_team,
       COALESCE(referee_name, 'Unknown') AS referee_name
FROM matches_flat
ORDER BY match_id
LIMIT 20;

-- Nema nijedan UKNOWN u koloni refree_name


-- 3.Zadatak

SELECT match_id, match_report,
       LENGTH(match_report) AS report_length
FROM matches_flat
WHERE LENGTH(match_report) > 40
ORDER BY report_length DESC, match_id;

-- Prikazano je 537 utakmica





-- 4. Zadatak  
SELECT match_id, kickoff_ts, home_team, away_team
FROM matches_flat
WHERE kickoff_ts >= '2025-01-01'
  AND kickoff_ts <  '2025-01-16'
ORDER BY kickoff_ts, match_id;



-- 5. Zadatak
SELECT DATE(kickoff_ts) AS match_date,
       DATE_FORMAT(kickoff_ts, 'EEEE') AS weekday_name,
       home_team, away_team
FROM matches_flat
WHERE DAYOFWEEK(kickoff_ts) = 6     
ORDER BY match_date;
 
SELECT COUNT(*) AS broj_utakmica
FROM matches_flat
WHERE DAYOFWEEK(kickoff_ts) = 6;
-- 0 utakmica, izgleda da ne vole da igraju petkom
 
-- 6. Zadatak
SELECT COUNT(*) AS broj_utakmica
FROM matches_flat
WHERE season = '2024/25'
  AND attendance BETWEEN 20000 AND 35000;
-- Ukupno 188 utakmica
 
 
-- 7. Zadatak
SELECT DISTINCT first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer LIKE 'A%'
   OR first_goal_scorer LIKE '%-%'
ORDER BY first_goal_scorer;
-- 20 fudbalera pocinju sa slovom A, a 2 fudbalera imaju crticu u imenu ( - )
 
 
-- 8. Zadatak
SELECT match_id, kickoff_ts, home_team, away_team
FROM matches_flat
WHERE season = '2024/25'
  AND DATE_FORMAT(kickoff_ts, 'HH:mm') BETWEEN '18:00' AND '21:00'
ORDER BY kickoff_ts, match_id;
-- 12 utakmica

 
 
-- 9. Zadatak
SELECT COUNT(*) AS broj_utakmica
FROM matches_flat
WHERE kickoff_ts >= '2025-03-01'
  AND kickoff_ts <  '2025-06-01'
  AND match_report ILIKE '%win%';
-- 5 utakimca sadrzi string "win"
