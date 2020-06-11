#include "CServiceLocator.h"

namespace masterclient {

CServiceLocator& CServiceLocator::get() {
	static CServiceLocator serv;
	return serv;
}

irr::scene::ISceneManager* CServiceLocator::getSceneManager() const {
	if (m_device == NULL) return NULL;
	return m_device->getSceneManager();
}

irr::IrrlichtDevice* CServiceLocator::getDevice() const {
	if (m_device == NULL) return NULL;
	return m_device;
}

irr::video::IVideoDriver* CServiceLocator::getDriver() const {
	if (m_device == NULL) return NULL;
	return m_device->getVideoDriver();
}

irr::scene::ISceneNode* CServiceLocator::getRootSceneNode() const {
	if (this->getSceneManager() != NULL){
		return this->getSceneManager()->getRootSceneNode();
	}
	return NULL;
}

irr::u32 CServiceLocator::getTime() const {
	if (m_device == NULL) return 0;
	return m_device->getTimer()->getRealTime();
}

CServiceLocator::CServiceLocator() {
	m_device = NULL;

}

CServiceLocator::~CServiceLocator() {
	m_device = NULL;
}

void CServiceLocator::setDevice(irr::IrrlichtDevice* _device) {
	m_device = _device;
}

} /* namespace masterclient */
