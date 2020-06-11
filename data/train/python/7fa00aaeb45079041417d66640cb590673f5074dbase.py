import flask
from flask import request
from flask_restful import Resource
from lbaas.repository.health_monitor_repository \
    import HealthMonitorRepositoryOps
from lbaas.repository.load_balancer_repository \
import LoadbalancerRepositoryOps
from lbaas.repository.pool_repository import PoolRepositoryOps
from lbaas.repository.member_repository import MemberRepositoryOps
from lbaas.repository.vip_repository import VipRepositoryOps
from lbaas.repository.lb_vip_repository import LbVipRepositoryOps
from lbaas.repository.content_swithcing_repository import ContentSwitchingRepositoryOps


class BaseService(Resource):
    def __init__(self):
        #Init persistence classes here ex:
        ##naming and links looks odd, figure how to chain differently
        self.lb_persistence = LoadbalancerRepositoryOps()
        self.monitor_persistence = HealthMonitorRepositoryOps()
        self.pool_persistence = PoolRepositoryOps()
        self.member_persistence = MemberRepositoryOps()
        self.vip_persistence = VipRepositoryOps()
        self.lb_vip_persistence = LbVipRepositoryOps()
        self.content_swithcing_repository = ContentSwitchingRepositoryOps()

    def validate_resources(self):
        resources = request.view_args.copy()
        if 'healthmonitor' in request.path and request.method != 'POST':
            resources['health_monitor'] = True
        self._validate_all_resources_exist(**resources)

    def _validate_all_resources_exist(self, tenant_id=None, lb_id=None,
                                      pool_id=None, member_id=None,
                                      health_monitor=False, vip_id=None):
        resources = []

        if pool_id is not None:
            pool = self.pool_persistence.pool.get(tenant_id, pool_id)
            resources.append(pool)
            if member_id is not None:
                resources.append(
                    self.member_persistence.member.get(pool_id, member_id))
            if health_monitor:
                resources.append(pool.health_monitor)

        if lb_id is not None:
            resources.append(self.lb_persistence.loadbalancer.get(tenant_id,
                                                                  lb_id))
        if vip_id is not None:
            resources.append(self.vip_persistence.vip.get(tenant_id,
                                                          vip_id))

        for resource in resources:
            if resource is None:
                flask.abort(404)
