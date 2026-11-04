# 1. Određivanje doba dana
# Napisati Python program koji za svaki sat u toku dana
# (od 0 do 23) ispisuje odgovarajuće doba dana:

# noć (od 22 do 6 časova),
# jutro (od 6 do 12 časova),
# popodne (od 12 do 18 časova) ili
# veče (od 18 do 22 časa).


for sat in range(24):
    if sat >= 22 or sat < 6:
        print(sat, "- noć")
    elif sat >= 6 and sat < 12:
        print(sat, "- jutro")
    elif sat >= 12 and sat < 18:
        print(sat, "- popodne")
    else:
        print(sat, "- veče")



# 0 - noć
# 1 - noć
# 2 - noć
# 3 - noć
# 4 - noć
# 5 - noć
# 6 - jutro
# 7 - jutro
# 8 - jutro
# 9 - jutro
# 10 - jutro
# 11 - jutro
# 12 - popodne
# 13 - popodne
# 14 - popodne
# 15 - popodne
# 16 - popodne
# 17 - popodne
# 18 - veče
# 19 - veče
# 20 - veče
# 21 - veče
# 22 - noć
# 23 - noć
