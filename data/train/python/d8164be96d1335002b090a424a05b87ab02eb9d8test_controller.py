import pytest
import conftest
import logging
from mock import Mock
from conpaas.core.controller import Controller


@pytest.fixture(scope='module')
def controller(cloud):
    ''' Params needed for initialisation of the controller '''
    logging.basicConfig()
    if (cloud.get_cloud_type() == 'dummy'):
        return None
    config_parser = conftest.config_parser(cloud.get_cloud_type())
    config_parser.add_section('manager')
    config_parser.set('manager', 'TYPE', 'helloworld')
    config_parser.set('manager', 'SERVICE_ID', '1')
    config_parser.set('manager', 'USER_ID', '123')
    config_parser.set('manager', 'CREDIT_URL',
                      'https://localhost:5555/credit')
    config_parser.set('manager', 'TERMINATE_URL',
                      'https://localhost:5555/terminate')
    config_parser.set('manager', 'CA_URL',
                      'https://localhost:5555/ca')
    config_parser.set('manager', 'APP_ID', '1')
    controller = Controller(config_parser)
    #we don't need timer for testing
    controller._Controller__reservation_map['manager'].stop()
    mockedController = Mock(spec=controller)
    #for testing purposes
    mockedController.deduct_credit.return_value = True
    mockedController._Controller__default_cloud = cloud
    mockedController._Controller__wait_for_nodes.return_value = \
        (mockedController._Controller__default_cloud.driver.list_nodes(), [])
    return mockedController


def test_create_nodes(controller):
    '''Creating nodes'''
    if controller is not None:
        assert controller.create_nodes(2, lambda ip, port: True, None)


def test_delete_nodes(controller):
    '''Deleting nodes'''
    if controller is not None:
        nodes_created = controller.create_nodes(2, lambda ip, port: True, None)
        assert controller.delete_nodes(nodes_created)


def test_multiple_cloud_providers(controller):
    '''Testing if we can store multiple clouds'''
    if controller is not None:
        assert controller._Controller__default_cloud is not None
        assert controller._Controller__available_clouds is not None
