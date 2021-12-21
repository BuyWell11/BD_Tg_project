from sqlalchemy import create_engine, select
from sqlalchemy.sql import func
from psycopg2 import OperationalError, Error
from config import password

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT



#connects to database
def create_connection():
    try:
        # Подключиться к существующей базе данных
        connection = psycopg2.connect(user="postgres",
                                      password=password,
                                      host="127.0.0.1",
                                      port="5432",
                                      database="project")

        print(connection)
    except (Exception, Error) as error:
        print("Ошибка при работе с PostgreSQL", error)

    return connection


def add_new_user_(con, id):
    cur = con.cursor()
    s = cur.callproc('add_new_user', [id, False])
    print(s)
    con.commit()
    row_count = cur.rowcount
    print(row_count)


def add_new_owner(con, id, name, email):
    cur = con.cursor()
    s = cur.callproc('add_new_owner', [id, name, email])
    print(s)
    con.commit()


def