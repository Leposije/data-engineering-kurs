
# 1. Zadatak

def get_even_positions(data: tuple) -> tuple:

    result = ()
    for i in range(0, len(data), 2):
        result += (data[i],)
    return result

print(get_even_positions((10, 20, 30, 40, 50, 60)))

# (10, 30, 50)


# 2.Zadatak
def find_exclusive_students(group1: set, group2: set) -> set:
    return group1 - group2

print(find_exclusive_students({'Ana', 'Marko', 'Jovan', 'Milica'}, {'Marko', 'Milica', 'Petar'}))

# {'Ana', 'Jovan'}


# 3.Zadatak
def clean_tags(text: str) -> str:
    tags = text.split('|')
    tags = [tag.strip().lower() for tag in tags]
    return '-'.join(tags)



print(clean_tags(' Python | DATA | SQL '))

# python-data-sql


# 4. Zadatak
def count_products(csv_lines: list) -> dict:
    products = {}

    for line in csv_lines[1:]:
        customer, product, quantity = line.strip().split(',')
        quantity = int(quantity)

        if product in products:
            products[product] += quantity
        else:
            products[product] = quantity

    return products

csv_data = [
    'customer,product,quantity',
    'Alice,laptop,2',
    'Bob,mouse,3',
    'Alice,laptop,1',
    'Charlie,keyboard,2',
    'Bob,mouse,1'
]


print(count_products(csv_data))




# {'laptop': 3, 'mouse': 4,'keyboard': 2}
