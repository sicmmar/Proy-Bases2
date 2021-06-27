import pymssql  
import os

conn = pymssql.connect(server='192.168.1.31', 
    user='SA', 
    password='amarillo8S*', 
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


    input("The title " + str(title) + " has been added.")
    eleccion = input("\n\n:: Would you like to add another title? [Y/n] > ")
    
    if eleccion == 'Y' or eleccion == 'y':
        new_title()

def inicio():
    print("\n\n **** WELCOME TO NETFLIX ****")
    print(" created by Mariana Sic \n\n")

    eleccion = input (":: Would you like to add new title? [Y/n] > ")
    if eleccion == 'Y' or eleccion == 'y':
        new_title()

    
    print("Thank you, see you later.")

inicio()