from pecan.rest import RestController

from .vnetworks import VNController
from .vmachines import VMController
from .ports import PortController, NWPortController
from .datapath import DatapathController
from .switch import SwitchController
from .domain import DomainController


class CNSController(RestController):

    datapaths = DatapathController()
    switches = SwitchController()
    domains = DomainController()
    virtualnetworks = VNController()
    virtualmachines = VMController()
    ports = PortController()
    nwports = NWPortController()
