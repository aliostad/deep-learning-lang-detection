#!/usr/bin/env python
import xml.etree.ElementTree as ET


class brocade_openflow(object):
    """Auto generated class.
    """
    def __init__(self, **kwargs):
        self._callback = kwargs.pop('callback')

            
    def openflow_controller_controller_name(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name = ET.SubElement(openflow_controller, "controller-name")
        controller_name.text = kwargs.pop('controller_name')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        
    def openflow_controller_connection_address_controller_address(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name_key = ET.SubElement(openflow_controller, "controller-name")
        controller_name_key.text = kwargs.pop('controller_name')
        connection_address = ET.SubElement(openflow_controller, "connection-address")
        controller_address = ET.SubElement(connection_address, "controller-address")
        controller_address.text = kwargs.pop('controller_address')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        
    def openflow_controller_connection_address_connection_method(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name_key = ET.SubElement(openflow_controller, "controller-name")
        controller_name_key.text = kwargs.pop('controller_name')
        connection_address = ET.SubElement(openflow_controller, "connection-address")
        connection_method = ET.SubElement(connection_address, "connection-method")
        connection_method.text = kwargs.pop('connection_method')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        
    def openflow_controller_connection_address_connection_port(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name_key = ET.SubElement(openflow_controller, "controller-name")
        controller_name_key.text = kwargs.pop('controller_name')
        connection_address = ET.SubElement(openflow_controller, "connection-address")
        connection_port = ET.SubElement(connection_address, "connection-port")
        connection_port.text = kwargs.pop('connection_port')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        
    def openflow_controller_controller_name(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name = ET.SubElement(openflow_controller, "controller-name")
        controller_name.text = kwargs.pop('controller_name')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        
    def openflow_controller_connection_address_controller_address(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name_key = ET.SubElement(openflow_controller, "controller-name")
        controller_name_key.text = kwargs.pop('controller_name')
        connection_address = ET.SubElement(openflow_controller, "connection-address")
        controller_address = ET.SubElement(connection_address, "controller-address")
        controller_address.text = kwargs.pop('controller_address')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        
    def openflow_controller_connection_address_connection_method(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name_key = ET.SubElement(openflow_controller, "controller-name")
        controller_name_key.text = kwargs.pop('controller_name')
        connection_address = ET.SubElement(openflow_controller, "connection-address")
        connection_method = ET.SubElement(connection_address, "connection-method")
        connection_method.text = kwargs.pop('connection_method')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        
    def openflow_controller_connection_address_connection_port(self, **kwargs):
        """Auto Generated Code
        """
        config = ET.Element("config")
        openflow_controller = ET.SubElement(config, "openflow-controller", xmlns="urn:brocade.com:mgmt:brocade-openflow")
        controller_name_key = ET.SubElement(openflow_controller, "controller-name")
        controller_name_key.text = kwargs.pop('controller_name')
        connection_address = ET.SubElement(openflow_controller, "connection-address")
        connection_port = ET.SubElement(connection_address, "connection-port")
        connection_port.text = kwargs.pop('connection_port')

        callback = kwargs.pop('callback', self._callback)
        return callback(config)
        