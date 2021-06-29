import pymssql  
import base64
import os

conn = pymssql.connect(server='192.168.1.31', 
    user='SA', 
    password= base64.b64decode('YW1hcmlsbG84Uyo='.encode('ascii')).decode('ascii'), 
    database='NETFLIX')

def new_title():
    cursor = conn.cursor()

    title = input (":: Enter the new title > ")
    year = input (":: Enter the year of release (default 0) > ")
    print('\n')
    cursor.execute('SELECT * FROM titletype;')

    row = cursor.fetchone()  
    while row:  
        print ("\t\t" + str(row[0]) + ". " + str(row[1]))     
        row = cursor.fetchone()  
    
    cod_type = input("\n:: Enter the type of your title > ")
    desc = input(":: Enter a short description > ")

    #res = cursor.execute('EXEC insert_title \'%' + str(title) + '%\', ' + str(year) + ', ' + str(cod_type) + ', \'' + str(desc) + '\';')
    res = cursor.callproc('insert_title', ('%' + str(title) + '%', str(year), str(cod_type), str(desc)))
    print("EL RESULTADO ES > ")
    print(res)
    input("\nThe title " + str(title) + " has been added.")
    eleccion = input("\n\n:: Would you like to add another title? [Y/n] > ")
    
    if eleccion == 'Y' or eleccion == 'y':
        new_title()
    else: menu()

def menu():
    print("\t1. Add new title")
    print("\t2. Search by title")
    print("\t3. Search by title with rating")
    print("\t4. Exit")
    option = input("\n:: What do you want to do? > ")

    if int(option) == 1:
        eleccion = input (":: Would you like to add new title? [Y/n] > ")
        if eleccion == 'Y' or eleccion == 'y':
            new_title()
        else: menu()
    elif int(option) == 4: exit()
    else: menu()

def inicio():
    print("\n\n **** WELCOME TO NETFLIX ****")
    print(" created by Mariana Sic \n\n")

    menu()

def exit():    
    print("Thank you, see you later.")

inicio()