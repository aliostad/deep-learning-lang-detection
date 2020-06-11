# -*- coding: utf-8 -*-

from speedycloud.products.cloud_server import CloudServerAPI
from speedycloud.products.cloud_volume import CloudVolumeAPI
from speedycloud.products.network import NetworkAPI
from speedycloud.products.cdn import CDNAPI
from speedycloud.products.video import VideoAPI
from speedycloud.products.load_balancer import LoadBalancerAPI
from speedycloud.products.cache import CacheAPI
from speedycloud.products.database import DatabaseAPI
from speedycloud.products.router import RouterAPI
from speedycloud.products import AbstractProductAPI
from speedycloud.object_storage.object_storage import ObjectStorageAPI
from speedycloud.products.porn_censor import CensorAPI


def create_cloud_server_api(access_key, secret_key):
    # 云主机
    cloud_server_api = CloudServerAPI(access_key, secret_key)
    return cloud_server_api


def create_cloud_volume_api(access_key, secret_key):
    # 云硬盘
    cloud_volume_api = CloudVolumeAPI(access_key, secret_key)
    return cloud_volume_api


def create_network_api(access_key, secret_key):
    # 网络
    network_api = NetworkAPI(access_key, secret_key)
    return network_api


def create_cdn_api(access_key, secret_key):
    # 云分发
    cdn_api = CDNAPI(access_key, secret_key)
    return cdn_api


def create_video_api(access_key, secret_key):
    # 视频
    video_api = VideoAPI(access_key, secret_key)
    return video_api


def create_load_balancer_api(access_key, secret_key):
    # 视频
    load_balancer_api = LoadBalancerAPI(access_key, secret_key)
    return load_balancer_api


def create_database_api(access_key, secret_key):
    # 数据库
    database_api = DatabaseAPI(access_key, secret_key)
    return database_api


def create_cache_api(access_key, secret_key):
    # 缓存
    cache_api = CacheAPI(access_key, secret_key)
    return cache_api


def create_router_api(access_key, secret_key):
    # 路由器
    router_api = RouterAPI(access_key, secret_key)
    return router_api


def create_object_storage_api(access_key, secret_key):
    # 对象存储
    object_storage_api = ObjectStorageAPI(access_key, secret_key)
    return object_storage_api


def create_censor_api(access_key, secret_key):
    # 鉴黄
    censor_api = CensorAPI(access_key, secret_key)
    return censor_api
