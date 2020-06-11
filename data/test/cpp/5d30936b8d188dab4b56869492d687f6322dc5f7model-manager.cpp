#include "model-manager.h"

ModelManager * ModelManager::m_modelManager;
ModelManager * ModelManager::getInstance ()
{
	if(!m_modelManager)
		m_modelManager = new ModelManager();
	return m_modelManager;
}

ModelManager::ModelManager()
{
	drawingTemporaryModel = NULL;
}

void ModelManager::setDrawingTemporaryModel (Model *value)
{
	this->drawingTemporaryModel = value;
}

Model * ModelManager::getDrawingTemporaryModel ()
{
	return this->drawingTemporaryModel;
}

void ModelManager::deleteDrawingTemporaryModel ()
{
	this->drawingTemporaryModel = NULL;
}

void ModelManager::commitDrawing ()
{
	this->m_modelList.append (drawingTemporaryModel);
	drawingTemporaryModel = NULL;
}

void ModelManager::insert(int index, Model *model)
{
	m_modelList.insert(index, model);
}

void ModelManager::removeAt(int index)
{
	m_modelList.removeAt(index);
}

void ModelManager::removeLast ()
{
	m_modelList.removeLast ();
}

int ModelManager::indexOf(Model *model)
{
	return m_modelList.indexOf(model);
}

int ModelManager::size()
{
	return m_modelList.size();
}

Model *ModelManager::at(int index)
{
	return m_modelList.at(index);
}

Model *ModelManager::last ()
{
	return m_modelList.last ();
}

void ModelManager::clear()
{
	m_modelList.clear();
}

void ModelManager::append(Model *model)
{
	m_modelList.append(model);
}

void ModelManager::swap(int i, int j)
{
	m_modelList.swap(i, j);
}

bool ModelManager::isCompleteModel (Model *model)
{

}

void ModelManager::draw ()
{
	for(int i = 0; i < m_modelList.size (); i++)
	{
		if(m_modelList.at (i)->getDrawingMode () == ObjectMode)
			m_modelList.at (i)->drawObjectMode ();
		else if(m_modelList.at (i)->getDrawingMode () == VertexMode)
			m_modelList.at (i)->drawVertexMode ();
	}
	if(drawingTemporaryModel != NULL)
		drawingTemporaryModel->drawVertexMode ();
}
