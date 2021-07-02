import sys
sys.path.append('../')

from pymongo import MongoClient
from client import main
from time import sleep
from daemonize import Daemonize

pid = "/tmp/collect-mongo.pid"

# Conectar a mongo
client = MongoClient(port=27017, host="3.21.100.69")

# Seleccionar base de datos y coleccion
db = client['Netflix']
collection = db.titles

def insert_data():
    for single_title in main.all_titles():
        # Obtener lista de codigos actuales en la base de datos de Netflix
        details = main.detailed_title(single_title)
        # Crear el objeto JSON
        title = {
            "_id": details[0],
            "primaryTitle": details[1],
            "isAdult": details[2],
            "startYear": details[3],
            "endYear": details[4],
            "runtime": details[5],
            "description": details[6],
            "titleType": details[7],
            "cast": main.cast_table(single_title),
            "director": main.get_creator(single_title, 'director'),
            "writer": main.get_creator(single_title, 'writer'),
            "genre": main.get_genres(single_title),
            "rating": {
                "averageRating": main.get_rating(single_title)[0],
                "numVotes": main.get_rating(single_title)[1]
            }
        }
        # Insertar objeto a Mongo
        collection.insert_one(title)

def first():
    while True:
        collection.drop()
        insert_data()
        sleep(71)

daemon = Daemonize(app="run_netflix", pid=pid, action=first())
daemon.start()