from pecan import expose, redirect, abort
from pecan.rest import RestController

import networks
import subnets
import ports
import routers
import floatingips
import securitygroups
import extensions

class Controller(RestController):

    networks = networks.Controller()
    subnets = subnets.Controller()
    ports = ports.Controller()
    routers = routers.Controller()
    floatingips = floatingips.Controller()
    extensions = extensions.Controller()

    @expose('json', content_type='application/json')
    def get(self):
        return {
            "resources": [
                {
                    "links": [
                        {
                            "href": "http://localhost:9696/v2.0/subnets",
                            "rel": "self"
                        }
                    ],
                    "name": "subnet",
                    "collection": "subnets"
                },
                {
                    "links": [
                        {
                            "href": "http://localhost:9696/v2.0/networks",
                            "rel": "self"
                        }
                    ],
                    "name": "network",
                    "collection": "networks"
                },
                {
                    "links": [
                        {
                            "href": "http://localhost:9696/v2.0/ports",
                            "rel": "self"
                        }
                    ],
                    "name": "port",
                    "collection": "ports"
                }
            ]
        }

    @expose()
    def _lookup(self, path, *remainder):
        if path == "security-groups":
            return securitygroups.Controller(), remainder
