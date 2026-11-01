-- 1. Za sezonu 2024/25 prikažite igrače i ukupan broj golova
-- koje su postigli. Prikažite samo igrače koji su postigli bar
-- jedan gol.

-- Pomoću DENSE
-- _
-- RANK() rangirajte igrače prema ukupnom broju
-- golova, od najvećeg ka najmanjem. Igrači sa istim brojem golova
-- treba da imaju isti rang.

SELECT p.player_id, p.first_name, p.last_name,
       COUNT(*) AS ukupno_golova,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rang
FROM match_events e
JOIN matches m ON m.match_id = e.match_id
JOIN players p ON p.player_id = e.player_id
WHERE m.season = '2024/25'
  AND e.event_type IN ('goal', 'penalty_goal')
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY rang, p.last_name;


-- 465	Calum	Fraser	12 golova	rang 8
-- 85	Luke	Gibbs	11 golova	rang 9
-- 347	Jamal	Holt	11 golova	rang 9
-- 293	Jamal	Kerr	10 golova	rang 10
-- 143	Harry	Gibbs	9  golova	rang 11
-- 321	Curtis	Jenkins	9  golova	rang 11



-- 2. Za sezonu 2024/25 prikažite tri igrača sa najviše
-- postignutih golova za svaki klub.

-- Prikažite naziv kluba, ime i prezime igrača i broj postignutih
-- golova. Pomoću ROW
-- _
-- NUMBER() odredite redosled igrača
-- unutar svakog kluba, od najvećeg ka najmanjem broju golova.


SELECT klub, ime, prezime, golova, redosled
FROM (
  SELECT t.team_name AS klub,
         p.first_name AS ime,
         p.last_name AS prezime,
         COUNT(*) AS golova,
         ROW_NUMBER() OVER (PARTITION BY t.team_name
                            ORDER BY COUNT(*) DESC, p.last_name) AS redosled
  FROM match_events e
  JOIN matches m ON m.match_id = e.match_id
  JOIN teams t   ON t.team_id   = e.team_id
  JOIN players p ON p.player_id = e.player_id
  WHERE m.season = '2024/25'
    AND e.event_type IN ('goal', 'penalty_goal')
  GROUP BY t.team_name, p.player_id, p.first_name, p.last_name
) x
WHERE redosled <= 3
ORDER BY klub, redosled;

-- za klub Ashfort Rovers
-- Ashford Rovers	Luke	Gibbs	golova: 11	rang 1
-- Ashford Rovers	Jonas	Becker	golova: 5	rang 2
-- Ashford Rovers	Jack	Cole	golova: 5	rang 3


-- 3. Za sezonu 2024/25 prikažite sve utakmice svakog kluba,
-- broj golova koje je klub postigao i broj golova koje je postigao
-- u svojoj prethodnoj utakmici.

-- Pomoću LAG() pronađite broj golova iz prethodne utakmice.
-- Izračunajte i razliku između broja golova na tekućoj i prethodnoj
-- utakmici. Rezultate sortirajte po nazivu kluba i datumu
-- utakmice.

WITH sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
         home_team_id AS team_id, home_goals AS goals_for
  FROM matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
         away_team_id, away_goals
  FROM matches
  WHERE status = 'played'
)
SELECT t.team_name AS klub,
       CAST(s.kickoff_ts AS DATE) AS datum,
       s.goals_for AS golovi,
       LAG(s.goals_for) OVER (PARTITION BY s.team_id ORDER BY s.matchday) AS golovi_prethodna,
       s.goals_for - LAG(s.goals_for) OVER (PARTITION BY s.team_id ORDER BY s.matchday) AS razlika
FROM sides s
JOIN teams t ON t.team_id = s.team_id
WHERE s.season = '2024/25'
ORDER BY t.team_name, s.kickoff_ts;

-- klub             datum       golovi | prethodni golovi | razlika |
-- Ashford Rovers	2024-08-17	0	        null	        null
-- Ashford Rovers	2024-08-24	3	        0	            3
-- Ashford Rovers	2024-09-02	0	        3       	    -3
-- Ashford Rovers	2024-09-14	0	        0	            0
-- Ashford Rovers	2024-09-21	1	        0         	    1