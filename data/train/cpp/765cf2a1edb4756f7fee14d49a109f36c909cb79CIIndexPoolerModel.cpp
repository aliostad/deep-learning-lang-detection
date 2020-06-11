#include "CIIndexPoolerModel.h"
#include "../Model/CIInfoIndexModel.h"

CCIIndexPoolerModel::CCIIndexPoolerModel(void)
{
}

CCIIndexPoolerModel::~CCIIndexPoolerModel(void)
{
	for (int i = 0; i < m_arrCIInfoIndexModel.size(); i++)
	{
		delete m_arrCIInfoIndexModel[i];
	}

	m_arrCIInfoIndexModel.clear();
}

CCIInfoIndexModel* CCIIndexPoolerModel::operator[](int iIndex)
{
	if (m_arrCIInfoIndexModel.size() > 0)
	{
		return m_arrCIInfoIndexModel[iIndex];
	}

	return NULL;
}

CCIIndexPoolerModel* CCIIndexPoolerModel::Clone()
{
	CCIIndexPoolerModel* pCIIndexPoolerModel = new CCIIndexPoolerModel();
	for (int i = 0; i < m_arrCIInfoIndexModel.size(); i++)
	{
		pCIIndexPoolerModel->Push(m_arrCIInfoIndexModel[i]->Clone());
	}

	return pCIIndexPoolerModel;
}