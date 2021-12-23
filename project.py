from sqlalchemy import create_engine, select
from sqlalchemy.sql import func
from psycopg2 import OperationalError, Error
from config import password

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


def create_connection():
    try:
        connection = psycopg2.connect(user="postgres",
                                      password=password,
                                      host="127.0.0.1",
                                      port="5432",
                                      database="project")

        print(connection)
    except (Exception, Error) as error:
        connection = psycopg2.connect(user="postgres",
                                      password=password,
                                      host="127.0.0.1",
                                      port="5432",
                                      database="postgres")

        print(connection)

    return connection


def add_new_user(con, user_id):
    cur = con.cursor()
    s = cur.callproc('add_new_user', [user_id, True])
    print(s)
    con.commit()


def add_new_owner(con, owner_id, name, email):
    cur = con.cursor()
    s = cur.callproc('add_new_owner', [owner_id, name, email])
    print(s)
    con.commit()


def add_new_client(con, client_id, client_name, client_email):
    cur = con.cursor()
    s = cur.callproc('add_new_client', [client_id, client_name, client_email])
    print(s)
    con.commit()


def add_new_item(con, item_name, item_space, owner_id):
    cur = con.cursor()
    s = cur.callproc('add_new_item', [item_name, item_space, owner_id])
    print(s)
    con.commit()


def add_new_sklad(con, owner_id, free_space, total_space, price_for_one_month):
    cur = con.cursor()
    s = cur.callproc('add_new_sklad', [owner_id, free_space, total_space, price_for_one_month])
    print(s)
    con.commit()


def add_new_contract(con, sklad_id_, client_id_, rent_duration_):
    cur = con.cursor()
    s = cur.callproc('add_new_contract', [sklad_id_, client_id_, rent_duration_])
    print(s)
    con.commit()


def general_item_space(con, client_id):
    cur = con.cursor()
    cur.callproc('general_item_space', [client_id])
    s = cur.fetchone()
    return s[0]


def available_sklads(con, client_id):
    cur = con.cursor()
    cur.callproc('available_sklads', [client_id])
    return cur.fetchall()


def info_about_items(con, client_id):
    cur = con.cursor()
    cur.callproc('info_about_items', [client_id])
    return cur.fetchall()


def info_about_owner_sklads(con, user_id):
    cur = con.cursor()
    cur.callproc('info_about_owner_sklads', [user_id])
    return cur.fetchall()


def info_about_client_contracts(con, client_id):
    cur = con.cursor()
    cur.callproc('info_about_client_contracts', [client_id])
    return cur.fetchall()


def info_about_owner_contracts(con, owner_id):
    cur = con.cursor()
    cur.callproc('info_about_owner_contracts', [owner_id])
    return cur.fetchall()


def is_user_admin(con, user_id):
    cur = con.cursor()
    cur.callproc('is_user_admin', [user_id])
    s = cur.fetchone()
    return s[0]


def del_sklad(con, sklad_id):
    cur = con.cursor()
    s = cur.callproc('del_sklad', [sklad_id])
    print(s)
    con.commit()


def reset_sklad_inc(con):
    cur = con.cursor()
    s = cur.callproc('reset_sklad_inc', [])
    print(s)
    con.commit()


def reset_contracts_inc(con):
    cur = con.cursor()
    s = cur.callproc('reset_contracts_inc', [])
    print(s)
    con.commit()


def reset_item_inc(con):
    cur = con.cursor()
    s = cur.callproc('reset_item_inc', [])
    print(s)
    con.commit()


def is_user_client(con, user_id):
    cur = con.cursor()
    cur.callproc('is_user_client', [user_id])
    s = cur.fetchone()
    return s[0]


def is_user_owner(con, user_id):
    cur = con.cursor()
    cur.callproc('is_user_owner', [user_id])
    s = cur.fetchone()
    return s[0]


def calculate_free_space(con, client_id, sklad_id):
    cur = con.cursor()
    s = cur.callproc('calculate_free_space', [client_id, sklad_id])
    print(s)
    con.commit()


def del_client(con, client_email):
    cur = con.cursor()
    s = cur.callproc('del_client', [client_email])
    print(s)
    con.commit()


def del_item(con, item_id):
    cur = con.cursor()
    s = cur.callproc('del_item', [item_id])
    print(s)
    con.commit()


def del_contract(con, contract_id):
    cur = con.cursor()
    s = cur.callproc('del_contract', [contract_id])
    print(s)
    con.commit()


def del_owner(con, owner_id):
    cur = con.cursor()
    s = cur.callproc('del_owner', [owner_id])
    print(s)
    con.commit()


def add_new_skladi_client(con, client_id, sklad_id):
    cur = con.cursor()
    s = cur.callproc('add_new_skladi_client', [client_id, sklad_id])
    print(s)
    con.commit()


def truncate_sklad_owner(con):
    cur = con.cursor()
    s = cur.callproc('truncate_sklad_owner', [])
    print(s)
    con.commit()


def truncate_skladi(con):
    cur = con.cursor()
    s = cur.callproc('truncate_skladi', [])
    print(s)
    con.commit()


def truncate_contracts(con):
    cur = con.cursor()
    s = cur.callproc('truncate_contracts', [])
    print(s)
    con.commit()


def truncate_client(con):
    cur = con.cursor()
    s = cur.callproc('truncate_client', [])
    print(s)
    con.commit()


def truncate_items(con):
    cur = con.cursor()
    s = cur.callproc('truncate_items', [])
    print(s)
    con.commit()


def truncate_skladi_client(con):
    cur = con.cursor()
    s = cur.callproc('truncate_skladi_client', [])
    print(s)
    con.commit()


def truncate_all_users(con):
    cur = con.cursor()
    s = cur.callproc('truncate_all_users', [])
    print(s)
    con.commit()


def truncate_all(con):
    cur = con.cursor()
    s = cur.callproc('truncate_all', [])
    print(s)
    con.commit()


def edit_client_info(con, client_id_, new_client_name, new_client_email):
    cur = con.cursor()
    cur.callproc('edit_client_info', [client_id_, new_client_name, new_client_email])
    return cur.fetchall()


def edit_user_status(con, user_id_, mode_):
    cur = con.cursor()
    s = cur.callproc('edit_user_status', [user_id_, mode_])
    print(s)
    con.commit()


def info_about_all_users(con):
    cur = con.cursor()
    cur.callproc('info_about_all_users', [])
    return cur.fetchall()


def info_about_clients(con, client_email):
    cur = con.cursor()
    cur.callproc('info_about_clients', [client_email])
    return cur.fetchall()


def show_all_clients(con):
    cur = con.cursor()
    cur.callproc('show_all_clients', [])
    return cur.fetchall()