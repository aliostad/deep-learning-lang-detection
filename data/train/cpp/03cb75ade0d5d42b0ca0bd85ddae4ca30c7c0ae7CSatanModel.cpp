#include "CSatanModel.h"

CSatanModel::CSatanModel(boost::shared_ptr<IModel> heroModel, boost::shared_ptr<IModel> satanModel)
: m_heroModel(heroModel->clone()), m_satanModel(satanModel)
{
	
}

//Definit l'animation du model (ou sous model...)
void CSatanModel::setAnim(std::string modelAnimName)
{
	m_heroModel->setAnim(modelAnimName);
}

//copie le modele
boost::shared_ptr<IModel> CSatanModel::clone() const
{
	boost::shared_ptr<IModel> newModel(new CSatanModel(m_heroModel,m_satanModel));
	return newModel;
}

void CSatanModel::setActiveHero(bool isActive)
{
	m_heroModel->setActive(isActive);
}

//Rend le drawable
void CSatanModel::RenderModel(sf::RenderTarget& target) const
{
	m_heroModel->SetPosition(40,25);
	m_satanModel->Render(target);
	target.Draw(*m_heroModel);
}