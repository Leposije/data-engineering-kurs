# 1. Zadatak

def safe_divide(a: float, b: float) -> float | None:
    try:
        return a / b
    except ZeroDivisionError:
        return None


print(safe_divide(10, 2))  
print(safe_divide(10, 0))  

# 5.0
# None

# 2. Zadatak


def safe_int(value: str) -> int | None:
    try:
        return int(value)
    except ValueError:
        return None


print(safe_int('25'))    # 25
print(safe_int('-10'))   # -10
print(safe_int('abc'))   # None



# 3. Zadatak 

def get_grade(grades: dict, student: str) -> int | None:
    try:
        return grades[student]
    except KeyError:
        return None


print(get_grade({'Ana': 5, 'Marko': 4, 'Jovana': 5}, 'Marko'))  # 4
print(get_grade({'Ana': 5, 'Marko': 4, 'Jovana': 5}, 'Petar'))  # None



# 4. Zadatak

R =  "/Workspace/Users/aleksa.lepovic@gmail.com/Python/data/raw/teams.csv"
import csv


def read_file(path: str) -> str:
    try:
        with open(path, 'r', encoding='utf-8') as file:
            return file.read()
    except FileNotFoundError:
        return 'File not found.'


print(read_file(R))

# team,city,points
# FK Jedinstvo,Bela Palanka,34
# FK Radnički,Niš,41
# FK Rakovica,"Beograd, Rakovica",28
# FK Sloga,Kraljevo,19




# Dodatni zadaci

# 5. Zadatak

def sum_numbers(values: list) -> float:
    total = 0.0

    for value in values:
        try:
            total += float(value)
        except ValueError:
            continue

    return total


print(sum_numbers(['10', '5.5', 'abc', '3', 'hello']))  

# 18.5, sabirace samo brojeve, za stringove ce se javiti ValuerError, njih ce preskociti



# 6. Zadatak

import csv
def get_age(csv_line: str) -> int | None:
    try:
        parts = csv_line.split(',')
        age = int(parts[1])
        return age
    except (IndexError, ValueError):
        return None


print(get_age('Ana,22'))       # 22
print(get_age('Marko,abc'))    # None
print(get_age('Jovana'))       # None