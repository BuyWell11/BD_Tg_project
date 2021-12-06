from sqlalchemy import create_engine
from psycopg2 import OperationalError

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


def create_connection():
    connection = psycopg2.connect(dbname="bd_project",
                                  user="postgres",
                                  password="runi124t",
                                  host="localhost")
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return connection


def add_new_user(user_id_):
    cursor.execute("SELECT user_id from all_users where user_id = %s ", (user_id_,))
    find_user = cursor.fetchone()

    if find_user == None:
        cursor.execute("INSERT INTO all_users VALUES ( %s )", (user_id_,))

    return True


connection = create_connection()

print(connection)

cursor = connection.cursor()

user = add_new_user(345)

cursor.execute("SELECT * FROM all_users")
record = cursor.fetchall()
print(record)

cursor.close()
connection.close()