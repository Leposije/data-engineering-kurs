-- 1. Prosek datih golova u poslednjih 5 utakmica, uz izričit
-- okvir prozora. Koja je najveća vrednost? Računajte
-- samo kada prozor zaista ima 5 utakmica.
WITH sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
        home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
        home_goals AS goals_for, away_goals AS goals_against
  FROM matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
        away_team_id, home_team_id, 'away',
        away_goals, home_goals
  FROM matches
  WHERE status = 'played'
),
r AS (
  SELECT t.team_name AS klub, s.season, CAST(s.kickoff_ts AS DATE) AS datum,
        AVG(s.goals_for) OVER (PARTITION BY s.team_id, s.season ORDER BY s.kickoff_ts
          ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS prosek_5,
        COUNT(*) OVER (PARTITION BY s.team_id, s.season ORDER BY s.kickoff_ts
          ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS utakmica_u_prozoru
  FROM sides s
  JOIN teams t ON t.team_id = s.team_id
)
SELECT klub, season, datum, ROUND(prosek_5, 2) AS prosek_5
FROM r
WHERE utakmica_u_prozoru = 5
ORDER BY prosek_5 DESC, datum
LIMIT 5;

-- Pemberton United	sezona:     2024/25	datum:2024-12-21	  prosek:   4.2
-- Castlebrook United	sezona:   2024/25	      2025-04-12	  prosek:   3.8
-- Castlebrook United	sezona:   2023/24	      2023-09-16	  prosek:   3.4
-- Pemberton United	sezona:     2023/24	      2024-03-02    prosek:   3.4
-- Kingsbridge City	seazona:    2024/25	      2024-10-05    prosek:   3.4



-- 2. Tekući zbir datih golova svakog kluba u sezoni
-- 2024/25: ko je prvi stigao do 50 golova i kada?

WITH sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
        home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
        home_goals AS goals_for, away_goals AS goals_against
  FROM matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
        away_team_id, home_team_id, 'away',
        away_goals, home_goals
  FROM matches
  WHERE status = 'played'
),
r AS (
  SELECT t.team_name AS klub, s.matchday, s.kickoff_ts,
        SUM(s.goals_for) OVER (PARTITION BY s.team_id ORDER BY s.kickoff_ts
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ukupno_golova
  FROM sides s
  JOIN teams t ON t.team_id = s.team_id
  WHERE s.season = '2024/25'
),
prvi AS (
  SELECT klub, MIN(kickoff_ts) AS kada
  FROM r
  WHERE ukupno_golova >= 50
  GROUP BY klub
)
SELECT p.klub, CAST(p.kada AS DATE) AS datum, r.matchday AS kolo, r.ukupno_golova
FROM prvi p
JOIN r ON r.klub = p.klub AND r.kickoff_ts = p.kada
ORDER BY p.kada;


-- Prvi je dostigao Kingsbridge City,  18. januar 2025.




-- 3. Za svaku domaću utakmicu izračunajte promenu
-- posećenosti u odnosu na prethodnu domaću utakmicu
-- istog kluba u istoj sezoni. Gde je najveći pad i zašto?

WITH domace AS (
  SELECT t.team_name AS klub, m.season, CAST(m.kickoff_ts AS DATE) AS datum,
        o.team_name AS protivnik, st.stadium_name AS stadion, st.capacity AS kapacitet,
        m.attendance AS poseta,
        LAG(m.attendance) OVER (PARTITION BY m.home_team_id, m.season
            ORDER BY m.kickoff_ts) AS prethodna_poseta
  FROM matches m
  JOIN teams t     ON t.team_id     = m.home_team_id
  JOIN teams o     ON o.team_id     = m.away_team_id
  JOIN stadiums st ON st.stadium_id = m.stadium_id
)
SELECT klub, season, datum, protivnik, stadion, kapacitet, poseta, prethodna_poseta,
       poseta - prethodna_poseta AS promena,
       ROUND(100.0 * (poseta - prethodna_poseta) / NULLIF(prethodna_poseta, 0), 1) AS promena_pct
FROM domace
WHERE poseta IS NOT NULL AND prethodna_poseta IS NOT NULL
ORDER BY promena ASC
LIMIT 3;


-- najveca promena je za klub Oakfield, pad sa 17864 na nula. Verovatno su bili suspendovani, pa ne smeju da imaju publiku.