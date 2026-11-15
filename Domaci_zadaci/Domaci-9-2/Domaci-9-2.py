# 1.Zdatak

class BankAccount:
    def __init__(self, owner, balance):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount: float):
        if amount > 0:
            self.balance += amount
        return self

    def withdraw(self, amount: float):
        if amount > 0 and amount <= self.balance:
            self.balance -= amount
        return self

    def display_balance(self):
        print("Stanje na racunu:", self.balance)


account = BankAccount("Ana", 10000)
account.deposit(5000).withdraw(2000).deposit(1000)
account.display_balance()

# Stanje na racunu: 14000



# 2.Zadatak


class UserProfile:
    def __init__(self, username, email, city):
        self.username = username
        self.email = email
        self.city = city
        self.active = True

    def change_email(self, email: str):
        self.email = email
        return self

    def change_city(self, city: str):
        self.city = city
        return self

    def deactivate(self):
        self.active = False
        return self

    def activate(self):
        self.active = True
        return self

    def display_info(self):
        print("Korisnicko ime:", self.username)
        print("Email:", self.email)
        print("Grad:", self.city)
        print("Aktivan:", self.active)


user = UserProfile("ana123", "ana@gmail.com", "Nis")
user.change_email("ana@yahoo.com").change_city("Beograd").deactivate()
user.display_info()


# Korisnicko ime: ana123
# Email: ana@yahoo.com
# Grad: Beograd
# Aktivan: False





# 3.Zadatak

class Product:
    def __init__(self, name, price, quantity):
        self.name = name
        self.price = price
        self.quantity = quantity

    def change_price(self, new_price: float):
        if new_price > 0:
            self.price = new_price
        return self

    def add_stock(self, amount: int):
        if amount > 0:
            self.quantity += amount
        return self

    def sell(self, amount: int):
        if amount > 0 and amount <= self.quantity:
            self.quantity -= amount
        return self

    def display_info(self):
        print("Naziv proizvoda:", self.name)
        print("Cena:", self.price)
        print("Kolicina na stanju:", self.quantity)


product = Product("Laptop", 80000, 10)
product.change_price(75000).sell(2).add_stock(5).sell(3)
product.display_info()


# Naziv proizvoda: Laptop
# Cena: 75000
# Kolicina na stanju: 10

