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
#account.deposit(5000).withdraw(2000).deposit(1000)
account.display_balance()

# Stanje na racunu: 14000



# 2.Zadatak

# 3.Zadatak

# 4.Zadatak