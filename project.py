from sqlalchemy import create_engine
from psycopg2 import OperationalError

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def create_connection():
    connection = psycopg2.connect(user="postgres", password="04022002")
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return connection

connection = create_connection()

print(connection)

cursor = connection.cursor()
cursor.execute('create database project')

cursor.close()
connection.close()
