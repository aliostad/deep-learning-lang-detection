from dao import controllers_dao
from handlers import installationHandler


def delete(serial_number, controller_ip):
    res = None
    if get_controller(serial_number, controller_ip):
        res = controllers_dao.delete_controller(serial_number, controller_ip)
    return res


def insert(controller):
    res = None
    if installationHandler.get(controller.get('installation')):
        if not controllers_dao.get_controller(controller.get('ip'), controller.get('installation')):
            res = controllers_dao.create_controller(controller)
    return res


def update(controller):
    res = False
    if get_controller(controller.get('installation'), controller.get('ip')):
        res = controllers_dao.update_controller(controller)
    return res


def get_controller(serial_number, controller_ip, internal=False):
    res = None
    if installationHandler.get(serial_number, internal):
        res = controllers_dao.get_controller(controller_ip, serial_number)
    return res


def get_controllers(serial_number):
    res = None
    if installationHandler.get(serial_number):
        res = controllers_dao.get_all(serial_number)
    return res
