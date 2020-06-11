/* 
 * File:   DeviceModel.cpp
 * Author: Ismael
 * 
 * Created on 9 de julio de 2014, 12:21 AM
 */


#include "Core.h"
#include "DeviceModel.h"


const std::string DeviceModel::id = "id";
const std::string DeviceModel::user_id = "user_id";
const std::string DeviceModel::access_token = "access_token";
const std::string DeviceModel::name = "name";
const std::string DeviceModel::status = "status";
const std::string DeviceModel::created = "created";
const std::string DeviceModel::modified = "modified";



const std::string DeviceModel::status_disconnected = "0";
const std::string DeviceModel::status_connected = "1";

DeviceModel::DeviceModel() : DatabaseModel("devices") {
}

DeviceModel::DeviceModel(const DeviceModel& orig) : DatabaseModel(orig.table_name) {
}

DeviceModel::~DeviceModel() {}



