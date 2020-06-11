#!usr/bin/env python
# -*- coding: utf-8 -*-
from flask import Flask
from flask.ext.restful import Api
from main.views import *


def create_app(cnf):
    app = Flask(__name__)
    app.config.from_object(cnf)
    db.init_app(app)
    api = Api(app)
    api.add_resource(UserList, '/api/v1.0/user', '/api/v1.0/user/')
    api.add_resource(UserResource, '/api/v1.0/user/<user_id>')
    api.add_resource(Login, '/api/v1.0/login', '/api/v1.0/login/')
    api.add_resource(BuildingList, '/api/v1.0/building', '/api/v1.0/building/')
    api.add_resource(BuildingResource, '/api/v1.0/building/<building_id>')
    api.add_resource(FloorList, '/api/v1.0/floor', '/api/v1.0/floor/')
    api.add_resource(FloorResource, '/api/v1.0/floor/<floor_id>')
    api.add_resource(RoomList, '/api/v1.0/room', '/api/v1.0/room/')
    api.add_resource(RoomResource, '/api/v1.0/room/<room_id>')
    api.add_resource(DeviceList, '/api/v1.0/device', '/api/v1.0/device/')
    api.add_resource(DeviceResource, '/api/v1.0/device/<device_id>')
    api.add_resource(dList, '/api/v1.0/data', '/api/v1.0/data/')
    api.add_resource(DataResource, '/api/v1.0/data/<data_id>')
    api.add_resource(sensorList, '/api/v1.0/sensor', '/api/v1.0/sensor/')
    api.add_resource(sensorResource, '/api/v1.0/sensor/<sensor_id>')
    api.add_resource(locationResource, '/api/v1.0/location/<uuid>')
    api.add_resource(locationList, '/api/v1.0/location', '/api/v1.0/location/')
    api.add_resource(dataSensor, '/api/v1.0/type/data', '/api/v1.0/type/data/')
    api.add_resource(dataList, '/api/v1.0/all/data', '/api/v1.0/all/data/')
    api.add_resource(
        locationInfor, '/api/v1.0/get/location', '/api/v1.0/get/location/')
    api.add_resource(time_data, '/api/v1.0/env/time', '/api/v1.0/env/time/')
    api.add_resource(
        timeSerial, '/api/v1.0/serial/time', '/api/v1.0/serial/time/')
    api.add_resource(
        sensorLocation, '/api/v1.0/device/location', '/api/v1.0/device/location/')
    api.add_resource(deviceData, '/api/v1.0/view/')

    return app
