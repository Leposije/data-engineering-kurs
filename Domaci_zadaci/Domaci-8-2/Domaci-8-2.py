# Рад са фајловима и CSV
# Фајлове увек отварати помоћу  with
# За CSV фајлове користити модул  csv
# Функције су задате у истом формату као на прошлом часу:
# func_name(var1: type, var2: type)-> type
# Фајл data/raw/teams.csv:
# team,city,pointsFK 
# Jedinstvo,Bela Palanka,34FK 
# Radnički,Niš,41FK
#  Rakovica,"Beograd, Rakovica"
#,28FK Sloga,Kraljevo,19
# Задаци са фајловима






# 16.
# Написати функцију
# count_lines(path: str) -> int
# која враћа број непразних редова у фајлу
# Input:
# 'data/raw/teams.csv'
# Output:
# 5


path = "/Workspace/Users/aleksa.lepovic@gmail.com/Python/data/raw/teams.csv"

# Nisam se snasao kako da oznacim folder kao working environment 
# u Databricks-u  pa da kucam samo ./data/raw/teams.csv za path
# tako da sam koristio full path

def count_lines(path: str) -> int:
    count = 0
    with open(path, 'r', encoding='utf-8') as file:
        for line in file:
            if line.strip() != '':
                count += 1
    return count





# 17.
# Написати функцију
# read_column(path: str, column: str) -> list
# која враћа све вредностиједне колоне CSV фајла
# Input:
# 'data/raw/teams.csv'
# ,
# 'city'
# Output:
# ['Bela Palanka', 'Niš', 'Beograd, Rakovica', 'Kraljevo']
# Ако колона не постоји, вратити празну листу
# []


def read_column(path: str, column: str) -> list:
    result = []
    with open(path, 'r', encoding='utf-8') as file:
        lines = file.readlines()
        headers = lines[0].strip().split(',')

        if column not in headers:
            return []

        index = headers.index(column)

        for line in lines[1:]:
            values = line.strip().split(',')
            result.append(values[index])

    return result



# 18.
# Написати функцију
# write_key_value(path: str, data: dict, headers: list) -> None
# којаречник уписује у CSV фајл са две колоне
# Input:
# 'data/processed/summary.csv'
# {'rows': 10, 'valid': 6}
# ['metric', 'value']

# Садржај фајла након позива:
# metric,value rows,10 valid,6


def write_key_value(path: str, data: dict, headers: list) -> None:
    with open(path, 'w', encoding='utf-8') as file:
        file.write(headers[0] + ',' + headers[1] + '\n')

        for key in data:
            file.write(str(key) + ',' + str(data[key]) + '\n')


# 19. Написати функцију get_header(path: str) -> list која враћа заглавље CSV фајла
# Користити csv.reader и next()
# Input: 'data/raw/teams.csv'
# Output: ['team', 'city', 'points']

import csv

def get_header(path: str) -> list:
    with open(path, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        header = next(reader)
        return header

# 20. Написати функцију read_rows(path: str) -> list која враћа све редове CSV фајла без
# заглавља, као листу листи
# Користити csv.reader
# Input: 'data/raw/teams.csv'
# Output: [['FK Jedinstvo', 'Bela Palanka', '34'], ['FK Radnički', 'Niš', '41'],
# ['FK Rakovica', 'Beograd, Rakovica', '28'], ['FK Sloga', 'Kraljevo', '19']]


def read_rows(path: str) -> list:
    result = []
    with open(path, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        next(reader)

        for row in reader:
            result.append(row)

    return result


# 21. Написати функцију total_points(path: str) -> int која враћа збир бодова свих тимова
# Користити csv.DictReader
# Input: 'data/raw/teams.csv'
# Output: 122


def total_points(path: str) -> int:
    total = 0
    with open(path, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)

        for row in reader:
            total += int(row['points'])

    return total


# 22. Написати функцију write_rows(path: str, rows: list) -> None која листу листи уписује у CSV
# фајл
# Input: 'data/processed/people.csv', [['name', 'age'], ['Ana', 20], ['Marko', 22]]
# Садржај фајла након позива:
# name,age
# Ana,20
# Marko,22


def write_rows(path: str, rows: list) -> None:
    with open(path, 'w', encoding='utf-8', newline='') as file:
        writer = csv.writer(file)

        for row in rows:
            writer.writerow(row)



# 23. Написати функцију write_dicts(path: str, rows: list) -> None која листу речника уписује у
# CSV фајл
# Користити csv.DictWriter; заглавља су кључеви првог речника
# Input: 'data/processed/people.csv', [{'name': 'Ana', 'age': 20}, {'name':
# 'Marko', 'age': 22}]
# Садржај фајла након позива:
# name,age
# Ana,20
# Marko,22



def write_dicts(path: str, rows: list) -> None:
    with open(path, 'w', encoding='utf-8', newline='') as file:
        headers = rows[0].keys()

        writer = csv.DictWriter(file, fieldnames=headers)
        writer.writeheader()

        for row in rows:
            writer.writerow(row)