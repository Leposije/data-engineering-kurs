-- 1. Koliko redova ima spoj matches i player_match_stats za
-- sezonu 2024/25? Objasnite.

SELECT COUNT(*)
FROM matches m
JOIN player_match_stats s ON s.match_id = m.match_id
WHERE m.season = '2024/25';

--15200 redova
-- jer smo vezali n match_id od player_match_stats tabele. U uvoj tabeli za jednu utakmicu se belezi za sve igracu na toj utakmici, tako da ce da se javlja mnnogo vise redova preko match_id.  Barem 22 igraca po utakmici.


-- 2. Koliko puta je igrač u istoj sezoni igrao za dva različita kluba?
SELECT COUNT(*)
FROM (
  SELECT s.player_id, m.season
  FROM player_match_stats s
  JOIN matches m ON m.match_id = s.match_id
  GROUP BY s.player_id, m.season
  HAVING COUNT(DISTINCT s.team_id) = 2 
) t;
-- 35 igraca je igralo za dva razlicita kluba u istoj sezoni

-- 3. Koliko utakmica ima više kartona od prosečne utakmice? Bez
-- kartona računajte sa 0.
WITH k AS (
  SELECT m.match_id, COUNT(e.event_id) AS kartoni
  FROM matches m
  LEFT JOIN match_events e
         ON e.match_id = m.match_id
        AND e.event_type IN ('yellow_card', 'second_yellow', 'red_card')
  GROUP BY m.match_id
)
SELECT COUNT(*) AS broj_utakmica
FROM k
WHERE kartoni > (SELECT AVG(kartoni) FROM k);

-- LEFT join koristimo kako bi dobili rezultate 0 za utakmice bez kartona kako bi radili statistiku proseka
-- 370 utakmica ima vise kartano od prosecne utakmice



-- 4. Koliko igrača je odigralo više od 10 utakmica u sezoni 2024/25?

SELECT COUNT(*) AS broj_igraca
FROM (
  SELECT s.player_id
  FROM player_match_stats s
  JOIN matches m ON m.match_id = s.match_id
  WHERE m.season = '2024/25' AND s.minutes_played > 0
  GROUP BY s.player_id
  HAVING COUNT(*) > 10
) t;
-- 383 igraca je  odigralo vise od 10 utakmica u sezoni 20224/25




-- 5. Prikažite sve klubove koji su igrali u sezoni 2024/25, bilo kao
-- domaćini ili kao gosti. Koristite UNION, a zatim izmenite upit
-- tako da koristi UNION ALL. Objasnite razliku u broju redova koji
-- dobijate.


-- UNION
SELECT t.team_name
FROM (
  SELECT home_team_id AS team_id FROM matches WHERE season = '2024/25'
  UNION
  SELECT away_team_id           FROM matches WHERE season = '2024/25'
) u -- U kao union
JOIN teams t ON t.team_id = u.team_id
ORDER BY t.team_name;

-- UNION ALL 
SELECT t.team_name
FROM (
  SELECT home_team_id AS team_id FROM matches WHERE season = '2024/25'
  UNION ALL
  SELECT away_team_id            FROM matches WHERE season = '2024/25'
) ua  -- ua kao union all
JOIN teams t ON t.team_id = ua.team_id
ORDER BY t.team_name;

-- Union vraća 20 redova, dok UNION ALL vraca 760. Funkcija UNION uklanja duplikate prilikom spajanja,  dakle svaki klub ce
-- da se pojavi samo jednom. Kod UNION ALL nista ne uklanja pa cemo dobiti mnogo vise domacina i gostiju klubova