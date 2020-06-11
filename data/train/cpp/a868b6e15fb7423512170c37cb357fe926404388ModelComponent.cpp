#include <Components/ModelComponent.hpp>

namespace emt
{
//
ModelComponent::ModelComponent()
	: verticesCopy{}
	, indicesCopy{}
	, uvCoordinatesCopy{}
	, colorValuesCopy{}
	, m_referenceCounter(1)
{

}
//
ModelComponent::ModelComponent(SimpleModel* model)
	: verticesCopy{}
	, indicesCopy{}
	, uvCoordinatesCopy{}
	, colorValuesCopy{}
	, m_referenceCounter(1)
{

	for (int i = 0; i < model->vertices.size(); i++)
	{
		verticesCopy.push_back(model->vertices.at(i));
	}
	
	for (int i = 0; i < model->indices.size(); i++)
	{
		indicesCopy.push_back(model->indices.at(i));
	}

}
//
ModelComponent::ModelComponent(SimpleModel model)
	: m_referenceCounter(1)
{

	for (int i = 0; i < model.vertices.size(); i++)
	{
		verticesCopy.push_back(model.vertices.at(i));
	}

	for (int i = 0; i < model.indices.size(); i++)
	{
		indicesCopy.push_back(model.indices.at(i));
	}

}
//
ModelComponent::~ModelComponent()
{
}
}
