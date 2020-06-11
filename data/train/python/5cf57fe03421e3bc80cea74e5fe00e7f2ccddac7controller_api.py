# coding:utf-8
from slice.models import Slice
from plugins.openflow.models import Controller
from slice.slice_exception import DbError, ControllerUsedError
from flowvisor_api import flowvisor_update_sice_controller
from django.db import transaction
from plugins.vt.api import create_vm_for_controller, delete_vm_for_controller
import logging
LOG = logging.getLogger("CENI")


def create_controller(slice_obj, controller_info):
    """创建控制器
    """
    if slice_obj:
        try:
            if controller_info['controller_type'] == 'default_create':
                controller = create_default_controller(slice_obj,
                                                       controller_info['controller_sys'])
            else:
                controller = create_user_defined_controller(slice_obj,
                                                            controller_info['controller_ip'],
                                                            controller_info['controller_port'])
            return controller
        except Exception:
            raise
    else:
        raise DbError("数据库异常")


def create_add_controller(slice_obj, controller_info):
    """创建并添加slice控制器
    """
    if slice_obj:
        try:
            if controller_info['controller_type'] == 'default_create':
                controller = create_default_controller(slice_obj,
                                                       controller_info['controller_sys'])
            else:
                controller = create_user_defined_controller(slice_obj,
                                                            controller_info['controller_ip'],
                                                            controller_info['controller_port'])
            slice_add_controller(slice_obj, controller)
            return controller
        except Exception:
            raise
    else:
        raise DbError("数据库异常")


def slice_add_controller(slice_obj, controller):
    """slice添加控制器
    """
    LOG.debug('slice_add_controller')
    if slice_obj and controller:
        if controller.is_used():
            raise ControllerUsedError('控制器已经被使用！')
        try:
            if not slice_obj.get_controller():
                slice_obj.add_resource(controller)
        except Exception:
            raise DbError("数据库异常")
    else:
        raise DbError("数据库异常")


def create_user_defined_controller(slice_obj, controller_ip, controller_port):
    """创建用户自定义控制器记录
    """
    if slice_obj:
        try:
            controller = Controller(
                name='user_define',
                ip=controller_ip,
                port=int(controller_port),
                island=slice_obj.get_island())
            controller.save()
            return controller
        except Exception:
            raise DbError("数据库异常")
    else:
        raise DbError("数据库异常")


def create_default_controller(slice_obj, controller_sys):
    """创建默认控制器
    """
    if slice_obj:
        island = slice_obj.get_island()
        try:
            vm, ip = create_vm_for_controller(island_obj=island,
                                              slice_obj=slice_obj,
                                              image_name=controller_sys)
        except Exception, ex:
            raise DbError(ex.message)
        try:
            controller = Controller(name=controller_sys,
                                    port=6633,
                                    island=island)
            controller.ip = ip
            controller.host = vm
            controller.save()
            return controller
        except Exception:
            if vm:
                try:
                    vm.delete()
                except:
                    pass
            raise DbError("数据库异常！")
    else:
        raise DbError("数据库异常！")


def delete_controller(controller, flag):
    """删除控制器
    """
    if controller:
        if controller.name == 'user_define':
            controller.delete()
        else:
            #先删除虚拟机然后删除controller记录
            if flag:
                if controller.host:
                    delete_vm_for_controller(controller.host)
                else:
                    controller.delete()


def slice_change_controller1(slice_obj, controller_info):
    """slice更改控制器
    """
    LOG.debug('slice_change_controller')
    if slice_obj:
        try:
            haved_controller = slice_obj.get_controller()
            if controller_info['controller_type'] == 'default_create':
                if haved_controller.name == controller_info['controller_sys']:
                    if haved_controller.host.state != 9:
                        return
            else:
                if haved_controller.name == 'user_define' and\
                        haved_controller.ip == controller_info['controller_ip'] and\
                        haved_controller.port == int(controller_info['controller_port']):
                    return
            slice_obj.remove_resource(haved_controller)
            controller = None
            controller = create_add_controller(slice_obj, controller_info)
            flowvisor_update_sice_controller(slice_obj.get_flowvisor(),
                                             slice_obj.id, controller.ip,
                                             controller.port)
        except Exception, ex:
            print 'c5'
            try:
                print 'c7'
                if controller:
                    delete_controller(controller, True)
                print 'c8'
                slice_obj.add_resource(haved_controller)
                print 'c9'
            except:
                print 'c10'
                pass
            raise DbError(ex.message)
        else:
            try:
                delete_controller(haved_controller, True)
            except:
                pass
    else:
        raise DbError("数据库异常")


@transaction.commit_manually
def slice_change_controller(slice_obj, controller_info):
    """slice更改控制器
    """
    LOG.debug('slice_change_controller')
    try:
        haved_controller = slice_obj.get_controller()
        if controller_info['controller_type'] == 'default_create':
            if haved_controller.name == controller_info['controller_sys']:
                if haved_controller.host.state != 9:
                    transaction.commit()
                    return
        else:
            if haved_controller.name == 'user_define' and\
                    haved_controller.ip == controller_info['controller_ip'] and\
                    haved_controller.port == int(controller_info['controller_port']):
                transaction.commit()
                return
        controller_n = create_controller(slice_obj, controller_info)
    except Exception:
        transaction.rollback()
        raise
    else:
        transaction.commit()
    try:
        slice_obj.remove_resource(haved_controller)
        slice_add_controller(slice_obj, controller_n)
        flowvisor_update_sice_controller(slice_obj.get_flowvisor(),
                                         slice_obj.id, controller_n.ip,
                                         controller_n.port)
    except Exception, ex:
        transaction.rollback()
        try:
            delete_controller(controller_n, True)
        except:
            pass
        transaction.commit()
        raise DbError(ex.message)
    else:
        transaction.commit()
        try:
            delete_controller(haved_controller, True)
        except:
            pass
        transaction.commit()
