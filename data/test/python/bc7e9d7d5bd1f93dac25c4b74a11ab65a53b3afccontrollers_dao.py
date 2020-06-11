#import MySQLdb
from exceptions.exceptions import *
import backend


def get_all(serial_number):
    sql = """SELECT * FROM controllers WHERE installation = %s"""
    return backend._query(sql, serial_number)


def get_controller(controller_ip, serial_number):
    sql = """SELECT * FROM `controllers` WHERE `ip` = %s AND `installation` = %s"""
    return backend._query_for_one(sql, controller_ip, serial_number)


def update_controller(controller):
    sql = """UPDATE controllers SET name = %s WHERE ip = %s AND installation = %s"""
    return backend._exec(sql, controller.get('name'), controller.get('ip'), controller.get('installation'))


def delete_controller(serial_number, controller_ip):
    sql = """DELETE FROM controllers WHERE installation = %s AND ip = %s"""
    return backend._exec(sql, serial_number, controller_ip)


def create_controller(controller):
    return backend._exec("""INSERT INTO controllers(`installation`, `ip`, `name`) VALUES(%s, %s, %s)""",
                         controller.get('installation'), controller.get('ip'), controller.get('name'))

