from sqlalchemy import create_engine
from psycopg2 import OperationalError

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


#connects to database
def create_connection():
    connection = psycopg2.connect(dbname="bd_project",
                                  user="postgres",
                                  password="runi124t",
                                  host="localhost")
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return connection


#adds new user if he hasn't existed
def add_new_user(user_id_):
    cursor.execute("SELECT user_id from all_users where user_id = %s ", (user_id_,))
    find_user = cursor.fetchone()

    if find_user == None:
        cursor.execute("INSERT INTO all_users VALUES ( %s )", (user_id_,))

    return True


#returns to client sum of his items' space
def general_item_space(client_id):
    cursor.execute("SELECT SUM(item_space) FROM items WHERE owner = %s", (client_id,))
    return cursor.fetchone()


#returns to client available warehouses, which are suitable for his items
def available_sklads(item_space_sum):
    cursor.execute("SELECT * FROM skladi WHERE free_space >= %s", (item_space_sum,))
    return cursor.fetchall()


#returns to user info about all of his items
def info_about_items(user_id_):
    cursor.execute("SELECT * FROM items WHERE owner = %s", (user_id_,))
    return cursor.fetchall()


#returns to owner info about all of his warehouses
def info_about_owner_sklads(owner_id_):
    cursor.execute("SELECT * FROM skladi WHERE owner_id = %s", (owner_id_,))
    return cursor.fetchall()


#returns to client all of his contracts
def info_about_client_contracts(client_id_):
    cursor.execute("SELECT * FROM contracts WHERE client_id = %s", (client_id_,))
    return cursor.fetchall()

#returns to owner all of his contracts
def info_about_owner_contracts(owner_id_):
    cursor.execute("SELECT contract_id, contracts.sklad_id, client_id, rent_duration, total_price "
                   "FROM contracts, skladi "
                   "WHERE contracts.sklad_id = skladi.sklad_id AND owner_id = %s", (owner_id_,))
    return cursor.fetchall()



connection = create_connection()

print(connection)

cursor = connection.cursor()



cursor.close()
connection.close()