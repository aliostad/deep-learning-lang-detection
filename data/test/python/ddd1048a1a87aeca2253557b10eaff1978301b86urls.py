from django.conf.urls import url

from . import UserController, VehicleController
from . import ProjectController, RecordController

app_name = 'controller'
urlpatterns = [
    url(r'^user/login', UserController.login),
    url(r'^user/logout', UserController.logout),
    url(r'^user/isLogin', UserController.isLogin),
    url(r'^user/current', UserController.getCurrentUser),

    url(r'^user/addUser', UserController.addUser),
    url(r'^user/deleteUser', UserController.deleteUser),
    url(r'^user/editUser', UserController.editUser),
    url(r'^user/getAllUser', UserController.getAllUser),
    url(r'^user/assignProject', UserController.assignProject),

    url(r'^vehicle/addVehicle', VehicleController.addVehicle),
    url(r'^vehicle/deleteVehicle', VehicleController.deleteVehicle),
    url(r'^vehicle/editVehicle', VehicleController.editVehicle),
    url(r'^vehicle/getAllVehicle', VehicleController.getAllVehicle),
    url(r'^vehicle/assignTask', VehicleController.assignTask),
    url(r'^vehicle/assignProject', VehicleController.assignProject),

    url(r'^project/addProject', ProjectController.addProject),
    url(r'^project/deleteProject', ProjectController.deleteProject),
    url(r'^project/editProject', ProjectController.editProject),
    url(r'^project/getAllProject', ProjectController.getAllProject),

    url(r'^record/getAllVehicleRecord', RecordController.getAllVehicleRecord),
    url(r'^record/deleteVehicleRecord', RecordController.deleteVehicleRecord),
    url(r'^record/getAllTaskRecord', RecordController.getAllTaskRecord),
    url(r'^record/deleteTaskRecord', RecordController.deleteTaskRecord),
    url(r'^record/getAllProjectUserRecord', RecordController.getAllProjectUserRecord),
    url(r'^record/deleteProjectUserRecord', RecordController.deleteProjectUserRecord),
    url(r'^record/getAllProjectVehicalRecord', RecordController.getAllProjectVehicalRecord),
    url(r'^record/deleteProjectVehicalRecord', RecordController.deleteProjectVehicalRecord),
]