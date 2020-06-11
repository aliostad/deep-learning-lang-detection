#include "DataModel.h"

DataModel* DataModel::m_pInstance = nullptr;

int DataModel::maxUnlock;
bool DataModel::isMusic = true;
bool DataModel::isSound = true;

bool DataModel::isShowTeaching = true;
bool DataModel::isFirstGame = true;
bool DataModel::isActivatingGame = false;

Vector<WayPoint*> DataModel::m_wayPoints;
Vector<Wave*> DataModel::m_waves;

DataModel::DataModel()
{
	_gameLayer = nullptr;
	_gameHUDLayer = nullptr;
}

DataModel::~DataModel()
{

}

DataModel* DataModel::getInstance()
{
	if (m_pInstance == nullptr)
	{
		m_pInstance = new DataModel();
		m_pInstance->initDataModel();
		return m_pInstance;
	}
	return m_pInstance;
}

void DataModel::initDataModel()
{
	maxUnlock = 1;
}
