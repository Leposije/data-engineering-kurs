-- Tim koji sam izabrao je "Lakeside Rangers" zvuci kul haha


-- 1. Сезона у бројевима: утакмице, победе, нерешене, порази, дати и примљени голови, бодови.
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers'
),
sides AS (
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
)
SELECT COUNT(*) AS utakmica,
       SUM(CASE WHEN goals_for >  goals_against THEN 1 ELSE 0 END) AS pobede,
       SUM(CASE WHEN goals_for =  goals_against THEN 1 ELSE 0 END) AS nereseno,
       SUM(CASE WHEN goals_for <  goals_against THEN 1 ELSE 0 END) AS porazi,
       SUM(goals_for) AS dati, SUM(goals_against) AS primljeni,
       SUM(CASE WHEN goals_for > goals_against THEN 3
                WHEN goals_for = goals_against THEN 1 ELSE 0 END) AS bodovi
FROM sides s JOIN club c ON c.team_id = s.team_id
WHERE s.season = '2024/25';

-- statistika 38 utakmica: 14 pobeda, 10 nerešenih, 14 poraza, golovi 60:61 (dati/primljeni), 52 boda



-- 2. Код куће и у гостима: исти бројеви, одвојено за домаће и гостујуће утакмице.
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers'
),
sides AS (
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
)
SELECT COUNT(*) AS utakmica,
       venue,
       SUM(CASE WHEN goals_for >  goals_against THEN 1 ELSE 0 END) AS pobede,
       SUM(CASE WHEN goals_for =  goals_against THEN 1 ELSE 0 END) AS nereseno,
       SUM(CASE WHEN goals_for <  goals_against THEN 1 ELSE 0 END) AS porazi,
       SUM(goals_for) AS dati, SUM(goals_against) AS primljeni,
       SUM(CASE WHEN goals_for > goals_against THEN 3
                WHEN goals_for = goals_against THEN 1 ELSE 0 END) AS bodovi
FROM sides s JOIN club c ON c.team_id = s.team_id
WHERE s.season = '2024/25'
GROUP BY venue;

-- Kao domacin: 8 pobeda, 6 nerešenih, 5 poraza, dati golovi 35, primljeni 24, dobijena boda 30 boda
-- U gostima :  6 pobeda, 4 nerešenih, 9 poraza, dati golovi 25, primljeni 37,  dobijena boda 22 boda



-- 3. Стрелци: три најбоља стрелца клуба и најбољи асистент.

WITH club AS (SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers')
SELECT p.first_name, p.last_name, COUNT(*) AS golovi
FROM match_events e
JOIN matches m ON m.match_id = e.match_id
JOIN club c ON c.team_id = e.team_id
JOIN players p ON p.player_id = e.player_id
WHERE m.season = '2024/25' AND e.event_type IN ('goal', 'penalty_goal')
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY golovi DESC
LIMIT 5;

-- 3 najbolja strelca:
-- Jamal	Kerr	    10 golova
-- Tyler	Dawson	    7 golova
-- Marcus	Fletcher	6 golova
-- Luke     Hughes      6 golova
-- Imamo dva igraca sa 6 golova, dele 3.mesto

-- sada upit za coveka sa najvise asistencija

WITH club AS (SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers')
SELECT p.player_id, p.first_name, p.last_name, COUNT(*) AS golovi
FROM match_events e
JOIN matches m ON m.match_id = e.match_id
JOIN club c ON c.team_id = e.team_id
JOIN players p ON p.player_id = e.related_player_id
WHERE m.season = '2024/25' AND e.event_type IN ('goal', 'penalty_goal')
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY golovi DESC
LIMIT 3;

-- Imamo dva igraca sa 3 assistencije,  Marko Jovanovic, Declan Foster, tako da ce tiebreaker da uradimo preko player_id
-- dakle Marko Jovanovic ima najvise asistencija




-- 4. Дисциплина: картони клуба по утакмици у поређењу са просеком лиге по тиму по утакмици.
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers'
),
sides AS (
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
kartoni AS (
  SELECT e.team_id, COUNT(*) AS k
  FROM match_events e
  JOIN matches m ON m.match_id = e.match_id
  WHERE m.season = '2024/25'
    AND e.event_type IN ('yellow_card', 'second_yellow', 'red_card')
  GROUP BY e.team_id
),
po_timu AS (
  SELECT team_id, COUNT(*) AS utakmica
  FROM sides WHERE season = '2024/25' GROUP BY team_id
)
SELECT ROUND(SUM(CASE WHEN u.team_id = (SELECT team_id FROM club) THEN k.k END)
           / SUM(CASE WHEN u.team_id = (SELECT team_id FROM club) THEN u.utakmica END), 2) AS klub_po_utakmici,
       ROUND(SUM(k.k) / SUM(u.utakmica), 2) AS liga_po_timu_po_utakmici
FROM po_timu u
LEFT JOIN kartoni k ON k.team_id = u.team_id;

-- Nas klub je dobio 1.39 kartona po utakmici. Dok u ligi tim u proseku ima  1.74 kartona po utakmici




-- 5. Тренери: ко је водио клуб у сезони и са колико бодова по утакмици.
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers'
),
sides AS (
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
)
SELECT ms.manager_name,
       COUNT(*) AS utakmica,
       SUM(CASE WHEN s.goals_for > s.goals_against THEN 3
                WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS bodovi,
       ROUND(SUM(CASE WHEN s.goals_for > s.goals_against THEN 3
                      WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) / COUNT(*), 2) AS bodova_po_utakmici
FROM sides s
JOIN club c ON c.team_id = s.team_id
JOIN manager_spells ms
  ON ms.team_id = s.team_id
 AND CAST(s.kickoff_ts AS DATE) >= CAST(ms.start_date AS DATE)
 AND CAST(s.kickoff_ts AS DATE) <= COALESCE(CAST(ms.end_date AS DATE), DATE'9999-12-31')
WHERE s.season = '2024/25'
GROUP BY ms.manager_name;


-- Menager je Vincent Kompany, 38 utakmica, 52 boda, 1.3 boda po utakmici




-- 6. Највећа победа и најтежи пораз.
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers'
),
sides AS (
  SELECT match_id, season, matchday, CAST(kickoff_ts as DAte) as datum,
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
)

SELECT CASE WHEN rnk_pobeda = 1 THEN 'Najveća pobeda' ELSE 'Najteži poraz' END AS tip,
       kickoff_ts, venue, protivnik, goals_for, goals_against
FROM (
  SELECT s.kickoff_ts, s.venue, o.team_name AS protivnik, s.goals_for, s.goals_against,
         RANK() OVER (ORDER BY s.goals_for - s.goals_against DESC) AS rnk_pobeda,
         RANK() OVER (ORDER BY s.goals_for - s.goals_against ASC)  AS rnk_poraz
  FROM sides s
  JOIN club c ON c.team_id = s.team_id
  JOIN teams o ON o.team_id = s.opponent_id
  WHERE s.season = '2024/25'
) x
WHERE rnk_pobeda = 1 OR rnk_poraz = 1
ORDER BY tip DESC, datum;

-- imamo 2 utakmice gde je nas tim dobio sa 5:0. Protiv timova Valemont United i Dunmore Celtic
-- Najveci poraz je protiv Elmsworth Wanderers 0:5




-- 7. Публика: просечна посета и попуњеност на домаћим утакмицама, и колико утакмица нема
-- податак о посети

WITH club AS (SELECT team_id FROM teams WHERE team_name = 'Lakeside Rangers')
SELECT COUNT(*) AS domacih_utakmica,
       ROUND(AVG(m.attendance)) AS prosecna_poseta,
       st.capacity,
       ROUND(100.0 * AVG(m.attendance) / st.capacity, 1) AS popunjenost,
       SUM(CASE WHEN m.attendance IS NULL THEN 1 ELSE 0 END) AS bez_podatka
FROM matches m
JOIN club c ON c.team_id = m.home_team_id
JOIN stadiums st ON st.stadium_id = m.stadium_id
WHERE m.season = '2024/25' AND m.status = 'played'
GROUP BY st.capacity;

-- Domacih utakmica ima 19, kapacitet 30500 a prosecna posecenost je 25482. Popunjenost u procentima 83.5%.  utakmice bez podataka o poseti je nula.




-- Utakmice sa najvecu i namjanju posecenost.
WITH club AS (
  SELECT team_id FROM bootcamp.northern_star.teams WHERE team_name = 'Lakeside Rangers'
)
SELECT CASE WHEN rnk_max = 1 THEN 'Najveća poseta' ELSE 'Najmanja poseta' END AS tip,
       datum, protivnik, poseta, popunjenost_pct, rezultat
FROM (
  SELECT CAST(m.kickoff_ts AS DATE) AS datum,
         o.team_name AS protivnik,
         m.attendance AS poseta,
         ROUND(100.0 * m.attendance / st.capacity, 1) AS popunjenost_pct,
         CONCAT(m.home_goals, ':', m.away_goals) AS rezultat,
         RANK() OVER (ORDER BY m.attendance DESC) AS rnk_max,
         RANK() OVER (ORDER BY m.attendance ASC)  AS rnk_min
  FROM bootcamp.northern_star.matches m
  JOIN club c ON c.team_id = m.home_team_id
  JOIN bootcamp.northern_star.teams o ON o.team_id = m.away_team_id
  JOIN bootcamp.northern_star.stadiums st ON st.stadium_id = m.stadium_id
  WHERE m.season = '2024/25' AND m.status = 'played' AND m.attendance IS NOT NULL
) x
WHERE rnk_max = 1 OR rnk_min = 1
ORDER BY poseta DESC;

-- Najveća poseta	2024-08-31	Thornbury City	    30126	    98.8	2:1
-- Najmanja poseta	2024-08-17	Redcliffe Athletic	22287	    73.1	3:1