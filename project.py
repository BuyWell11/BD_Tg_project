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


def general_item_space(client_id):
    cursor.execute("SELECT SUM(item_space) FROM items WHERE owner = %s", (client_id,))
    return cursor.fetchone()


def available_sklads(item_space_sum):
    cursor.execute("SELECT * FROM skladi WHERE free_space >= %s", (item_space_sum,))
    return cursor.fetchall()


def info_about_items(user_id_):
    cursor.execute("SELECT * FROM items WHERE owner = %s", (user_id_,))
    return cursor.fetchall()


def info_about_owner_sklads(owner_id_):
    cursor.execute("SELECT * FROM skladi WHERE owner_id = %s", (owner_id_,))
    return cursor.fetchall()


connection = create_connection()

print(connection)

cursor = connection.cursor()


cursor.close()
connection.close()