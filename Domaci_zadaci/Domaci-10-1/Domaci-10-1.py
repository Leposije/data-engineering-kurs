
import pandas as pd

# Ucitavanje podataka
teams = pd.read_csv("/Volumes/bootcamp/northern_star/raw_2025_26/teams_2025_26.csv")
matches = pd.read_csv("/Volumes/bootcamp/northern_star/raw_2025_26/matches_2025_26.csv")


# 1. Zadatak

# 1) Utakmice u kojima su oba tima postigla bar jedan gol
result = matches[
    (matches["home_goals"] >= 1) &
    (matches["away_goals"] >= 1)
]

print(result)

# 178 utakmica


# 2) Utakmice u kojima je domacin pobedio sa tacno jednim golom razlike

result = matches[
    (matches["home_goals"] - matches["away_goals"] == 1)
]

print(result)

#105 utakmica


# 3) Koliko utakmica je zavrseno rezultatom 0:0


result = matches[
    (matches["home_goals"] == 0) &
    (matches["away_goals"] == 0)
]

print(len(result))

# 26 utakmica


# 4) Prikazati 10 utakmica sa najvise postignutih golova

matches["total_goals"] = (matches["home_goals"] + matches["away_goals"])

result = matches.sort_values("total_goals", ascending=False).head(10)

print(result)

# prvo mesto 9, drugo mesto 8, trece mesto 7, 6 timova sa 6 gola , i jedan sa 5









# 2. Analiza jednog time, uzeli smo Ravenscar Albion

team = "Ravenscar Albion"


# 1) Prikazati sve utakmice u kojima je ucestvovao

team = "Ravenscar Albion"
team_code = teams.loc[teams["team_name"] == team, "team_code"].iloc[0]

result = matches[
    (matches["home_team"] == team_code) |
    (matches["away_team"] == team_code)
]
print(result)

# 180 utakmica




# 2) Koliko puta je pobedio, izgubio i igrao nereseno
wins = 0
losses = 0
draws = 0

for index, row in result.iterrows():
    if row["home_team"] == team:
        if row["home_goals"] > row["away_goals"]:
            wins += 1
        elif row["home_goals"] < row["away_goals"]:
            losses += 1
        else:
            draws += 1

    else:
        if row["away_goals"] > row["home_goals"]:
            wins += 1
        elif row["away_goals"] < row["home_goals"]:
            losses += 1
        else:
            draws += 1

print("n2. Rezultati tima:")
print("Pobede:", wins)
print("Porazi:", losses)
print("Nereseno:", draws)


# Pobede: 11
# Porazi: 19
# Nereseno: 8



# 3) Broj postignutih golova kao domacin i kao gost

home_goals = matches[matches["home_team"] == team_code]["home_goals"].sum()
away_goals = matches[matches["away_team"] == team_code]["away_goals"].sum()

print("Golovi kao domacin:", home_goals)
print("Golovi kao gost:", away_goals)

# Golovi kao domacin: 22
# Golovi kao gost: 11


# 4) Utakmica u kojoj je tim postigao najvise golova
team_matches = result.copy()

team_matches["goals_scored"] = team_matches.apply(
    lambda row: row["home_goals"]
    if row["home_team"] == team_code
    else row["away_goals"],
    axis=1
)

result_max = team_matches.sort_values("goals_scored", ascending=False).head(1)

print(result_max)








# 3. Analiza stadiona


# Povezivanje utakmica sa podacima o stadionima
stadiums = teams[["team_code", "home_stadium"]]

matches_stadiums = matches.merge(
    stadiums,
    left_on="home_team",
    right_on="team_name"
)

print(teams["home_stadium"].unique())


# Svi stadioni:
# ['Crowsnest' 'The Foundry' 'Ridgeway Stadium' 'Harrow Lane' 'Vale Park'
#  'Quarry Park' 'Moorside Arena' 'Saltworks Road' 'Shoreline Stadium'
#  'Timber Lane' 'Antler Park' 'Fellside' 'Coldharbour Dome'
#  'Northern Lights Arena' 'Glacier Road' 'Bramble Field' 'Estuary Ground'
#  'Kelda Bridge Ground' 'Harbour Park' 'Lighthouse Stadium']





# 2. Stadion na kojem je odigrano najvise utakmica

result = matches_stadiums["home_stadium"].value_counts().head(1)

print(result)

#Series([], Name: count, dtype: int64)



# 3. Prosecna posecenost za svaki stadion

result = matches_stadiums.groupby("home_stadium")["attendance"].mean()

print(result)

#Series([], Name: count, dtype: int64)



# 4. Pet stadiona sa najvecom prosecnom posecenoscu

result = matches_stadiums.groupby("home_stadium")
["attendance"].mean().sort_values(ascending=False).head(5)

print(result)

# Lighthouse Stadium    24214.53
# Harbour Park          23820.63
# The Foundry           23818.84
# Moorside Arena        21719.89
# Northern Lights Arena 20953.11