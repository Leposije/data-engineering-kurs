-- 1.Zadatak
SELECT season,
       COUNT(*) AS broj_utakmica,
       SUM(home_goals + away_goals) AS ukupno_golova,
       ROUND(AVG(home_goals + away_goals), 2) AS prosek_golova
FROM matches_flat
WHERE status = 'played'
GROUP BY season
ORDER BY season;

-- Sezona 2023/24, broj utakmica 380, golova 1046, prosek 2,75
-- Sezona 2024/25, broj utakmica 380, golova 1092, prosek 2,87


-- 2. Zadatak
SELECT stadium_name,
       MIN(attendance) AS min_poseta,
       MAX(attendance) AS max_poseta,
       ROUND(AVG(attendance), 0) AS prosek_poseta,
       COUNT(attendance) AS utakmica_sa_posetom
FROM matches_flat
GROUP BY stadium_name
ORDER BY max_poseta DESC;

-- Stadion	| Min | Max |	Prosek	| Poznata poseta
-- Harbourside Park      | 37.641 |	50.922	| 44.416 | 38
-- Kingsbridge Stadium  |	33.872	| 46.824	|40.091	38
-- Northport Arena	 |   29.777  |	40.844  |	35.266  |	36

-- Da li postoji neki laksi nacin? Mrzi me da kucam ovoliko.. :')

-- 3. Zadatak
SELECT referee_name AS sudija,
       COUNT(*) AS broj_utakmica,
       SUM(home_yellow_cards + away_yellow_cards) AS zuti_kartoni
FROM matches_flat
GROUP BY referee_name
HAVING COUNT(*) >= 10
   AND SUM(home_yellow_cards + away_yellow_cards) >= 20
ORDER BY zuti_kartoni DESC;

-- Sudija,  broj utakmica, ZUti kartoni
-- Henrik Dahl, 40, 162... sledeci je sa 162, pa 154, 153 zutih kartona

-- 4. Zadatak
SELECT CASE
         WHEN home_goals + away_goals = 0 THEN 'Bez golova'
         WHEN home_goals + away_goals <= 2 THEN 'Malo golova'
         ELSE 'Mnogo golova'
       END AS kategorija,
       COUNT(*) AS broj_utakmica,
       MAX(home_goals + away_goals) AS max_golova
FROM matches_flat
WHERE status = 'played'
GROUP BY 1
ORDER BY max_golova;

-- bez golova, 41 utakmica, 0
-- malo golova, 330 utakmica, max golova 2 
-- Mnogo golova, 389 utakmica, max golova 9

-- 5. Zadatak
SELECT home_team AS klub,
       COUNT(*) AS utakmica_kod_kuce,
       SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS pobede,
       SUM(CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END) AS porazi
FROM matches_flat
WHERE status = 'played'
GROUP BY home_team
HAVING COUNT(*) >= 10
ORDER BY pobede DESC;

-- Northport city, utakmice kod kuce 38, pobede 26, porazi 4
-- Harrowgate Albion, kuci 38, pobede 24, porazi 9
-- Stonebridge Rovers, kuci 38, pobede 23, porazi 7...



-- 6. Zadatak
SELECT referee_name AS sudija,
       COUNT(*) AS broj_utakmica,
       SUM(CASE WHEN home_red_cards + away_red_cards >= 1 THEN 1 ELSE 0 END) AS sa_crvenim,
       ROUND(100.0 * SUM(CASE WHEN home_red_cards + away_red_cards >= 1 THEN 1 ELSE 0 END)
             / COUNT(*), 1) AS procenat
FROM matches_flat
GROUP BY referee_name
ORDER BY procenat DESC, sudija;

-- Craig Pawson, broj utakmica 40, sa crvenim 8, 20% 
-- Robert Kane , broj utakmica 40, sa 8 crvenim , 20%
-- Micheal Oliver Hart, broj utakmica 40, sa 7 crvenim, 17.5%


-- 7. Zadatak
SELECT season,
       SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS pobede_domacina,
       SUM(CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END) AS nereseno,
       SUM(CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END) AS pobede_gostiju,
       ROUND(100.0 * SUM(CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS procenat_neresenih
FROM matches_flat
WHERE status = 'played'
GROUP BY season
ORDER BY season;

-- Sezona 2023/24, pobede domacina 172, nereseno 96, pobede gosti 112
-- Sezona 2024/25, pobede domacina 157, nereseno 95, pobede gosti 128