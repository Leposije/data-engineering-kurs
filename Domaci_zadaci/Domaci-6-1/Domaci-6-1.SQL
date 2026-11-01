-- 1. Kreiranje dimenzije igrača
-- Na osnovu tabele players napravite tabelu dim_player koja sadrži sledeće kolone: player_id, ime, prezime, poziciju i nacionalnost igrača. Koliko redova ima novokreirana tabela?
CREATE OR REPLACE TABLE dim_player AS
SELECT player_id,
       first_name  AS ime,
       last_name   AS prezime,
       position    AS pozicija,
       nationality AS nacionalnost
FROM players;

SELECT COUNT(*) AS redova_dim_player FROM dim_player;

-- 681 red.




-- 2. Kreiranje dimenzije datuma i činjenične tabele
-- Napravite tabelu dim_date na isti način kao na predavanju. Zatim napravite tabelu fact_player_match na osnovu tabela player_match_stats i matches. Tabela treba da sadrži
-- sledeće kolone: match_id, date_key, player_id, team_id, minutes_played, shots, passes i rating.

-- U tabelu uključite samo podatke koji se odnose na odigrane
-- utakmice.
-- Kolika je granularnost tabele fact_player_match, odnosno
-- šta predstavlja jedan njen red?
-- Koliko redova ima ova tabela?

CREATE OR REPLACE TABLE dim_date AS
SELECT CAST(DATE_FORMAT(d, 'yyyyMMdd') AS INT) AS date_key,
       d                                       AS full_date,
       DATE_FORMAT(d, 'EEEE')                  AS weekday_name,
       DAYOFWEEK(d) IN (1, 7)                  AS is_weekend,
       CASE WHEN MONTH(d) >= 7 THEN CONCAT(YEAR(d), '/', SUBSTRING(CAST(YEAR(d) + 1 AS STRING), 3, 2))
            ELSE CONCAT(YEAR(d) - 1, '/', SUBSTRING(CAST(YEAR(d) AS STRING), 3, 2))
       END                                     AS season
FROM (SELECT EXPLODE(SEQUENCE(DATE'2023-07-01', DATE'2025-06-30', INTERVAL 1 DAY)) AS d);



-- fact_player_match, jedan red predstavlja  jednog igraca na utakmici
CREATE OR REPLACE TABLE fact_player_match AS
SELECT s.match_id,
       d.date_key,
       s.player_id,
       s.team_id,
       s.minutes_played,
       s.shots,
       s.passes,
       s.rating
FROM player_match_stats s
JOIN matches m  ON m.match_id = s.match_id
JOIN dim_date d ON d.full_date = CAST(m.kickoff_ts AS DATE)
WHERE m.status = 'played';

SELECT COUNT(*) AS redova_fact_player_match FROM fact_player_match;
-- 30400




-- 3. Prosecna ocena po poziciji, sezona 2024/25
SELECT p.pozicija, ROUND(AVG(f.rating), 2) AS prosecna_ocena
FROM fact_player_match f
JOIN dim_date d   ON d.date_key  = f.date_key
JOIN dim_player p ON p.player_id = f.player_id
WHERE d.season = '2024/25' AND NOT isnan(f.rating)
GROUP BY p.pozicija
ORDER BY prosecna_ocena DESC;

-- FW	6.79
-- MF	6.72
-- DF	6.64
-- GK	6.6

-- Ovde sam dolazio do problema, iz nekog razloga dobijam da su sve prosecne ocene NaN vrednost. 
-- Tako da sam samo stavio u WHERE uslov da rating nije NaN. Valjda su vrednosti ok. 




-- 4. Dodavanje broja golova u činjeničnu tabelu
-- Proširite tabelu fact_player_match dodavanjem kolone koja
-- predstavlja broj golova koje je svaki igrač postigao na
-- određenoj utakmici. Koliki je ukupan zbir golova svih igrača u tabeli
-- fact_player_match?

-- dodajemo kolonu goals
ALTER TABLE fact_player_match ADD COLUMN goals INT;


MERGE INTO fact_player_match f
USING (
  SELECT match_id, player_id, COUNT(*) AS golova
  FROM match_events
  WHERE event_type IN ('goal', 'penalty_goal')
  GROUP BY match_id, player_id
) g
ON f.match_id = g.match_id AND f.player_id = g.player_id
WHEN MATCHED THEN UPDATE SET f.goals = g.golova;




-- menjamo null vrednosti golova sa nulom
UPDATE fact_player_match SET goals = 0 WHERE goals IS NULL;


SELECT SUM(goals) AS golova_u_fact_tabeli
FROM fact_player_match;
-- 2043 golova u fact_player_match