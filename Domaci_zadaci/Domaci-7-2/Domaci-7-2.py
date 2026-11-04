# 0.1 Napisati program kojim se prevodi temperatura iz Celzijusove skale u Farenhajtovu skalu,
# ako je odgovaraju´ca formula oblika T [◦F] = T [◦C] · 1.80 + 32. Na ulazu se unosi vrednost
# temperature u stepenima Celzijusa (realan broj) a ispisuje se vrednost temperature u stepenima
# Farenhajta.

def Feren(temp):
    konv = temp *1.80 +32
    return konv
print (Feren(13.2))

## Temperatura u ferenhajtima je  55.76 za 13.2 celziujus



# 0.2.Napisati program koji za uneti redni broj dana u nedelji (od 1 do 7) ispisuje naziv tog
# dana (ponedeljak - nedelja). Ukoliko je unet broj koji nije izmed¯u 1 i 7, ispisati Pogresan
# unos.

dani = ("Ponedeljak", "Utorak", "Sreda", "Cetvrtak",
        "Petak", "Subota", "Nedelja")

def dan_ned(broj):
    if broj >= 1 and broj <= 7:
        return dani[broj - 1]
    else:
        return "Unknown"
    
print(dan_ned(9))
print(dan_ned(6))
print(dan_ned(2))

## Ispisace dane:
# Unknown
#Subota
#Utorak



# 0.3 Najveći negativni element u listi

def najveci_negativni(lista):
    najveci = None

    for i in lista:
        if i < 0:
            if najveci == None or i > najveci:
                najveci = i

    return najveci


lista = [-5, 3, -2, 8, -9, -1]
print(najveci_negativni(lista))


## najveci negativni je -1



# 0.5. Napisati program koji raˇcuna broj parnih elemenata date liste.

def broj_parnih(lista):
    brojac = 0

    for i in lista:
        if i % 2 == 0:
            brojac += 1

    return brojac


lista = [2, -5, 8, 3, -10, 17]
print(broj_parnih(lista))

# 3 parna broja





# 0.6  Sume elemenata deljivih sa 2 i sa 3

def sume(lista):
    suma2 = 0
    suma3 = 0

    for i in lista:
        if i % 2 == 0:
            suma2 += i

        if i % 3 == 0:
            suma3 += i

    return suma2, suma3


lista = [2, 3, 4, 6, 9, 12, 5]
print(sume(lista))

## (24,30)