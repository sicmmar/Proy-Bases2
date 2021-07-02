import pymssql  
import base64
import os

conn = pymssql.connect(server='192.168.1.31', 
    user='SA', 
    password= base64.b64decode('YW1hcmlsbG84Uyo='.encode('ascii')).decode('ascii'), 
    database='NETFLIX')

cursor = conn.cursor()

def all_titles():
    cursor.execute('SELECT id FROM title;')
    titles = []
    row = cursor.fetchone()
    while row:
        titles.append(str(row[0]))
        row = cursor.fetchone()

    return titles

def cast_table(id_title):
    cursor.execute("SELECT p.name FROM crew c INNER JOIN person p ON c.personId = p.id INNER JOIN role r ON c.roleId = r.id WHERE c.titleId = '" + str(id_title) + "' AND (r.name = 'actress' OR r.name = 'actor');")
    cast = []
    row = cursor.fetchone()
    while row:
        cast.append(str(row[0]))
        row = cursor.fetchone()
    return cast

def detailed_title(id_title):
    cursor.execute("SELECT t.id, t.primaryTitle, t.isAdult, t.startYear, t.endYear, t.runtime, t.[description], tp.name FROM title t INNER JOIN titletype tp ON t.titleTypeId = tp.id WHERE t.id = '" + str(id_title) + "';")
    return cursor.fetchone()

def get_genres(id_title):
    cursor.execute("SELECT g.name FROM title_genre tg INNER JOIN genre g ON tg.genreId = g.id WHERE tg.titleId = '" + str(id_title) + "';")
    genres = []
    row = cursor.fetchone()
    while row:
        genres.append(str(row[0]))
        row = cursor.fetchone()
    return genres

def get_creator(id_title, role):
    cursor.execute("SELECT p.name FROM crew c INNER JOIN person p ON c.personId = p.id INNER JOIN role r ON c.roleId = r.id WHERE c.titleId = '" + id_title + "' AND r.name = '" + role + "';")
    return cursor.fetchone()[0]

def get_rating(id_title):
    cursor.execute("SELECT r.averageRating, r.numVotes FROM [192.168.1.2].IMDB.dbo.rating r WHERE r.titleId = '" + id_title + "';")
    row = cursor.fetchone()
    return [float(row[0]), int(row[1])]

def new_title():
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
