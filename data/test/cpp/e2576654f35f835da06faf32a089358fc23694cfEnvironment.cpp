#include "Environment.h"
#include "Ground.h"

Model::Environment::Environment(const Model::Environment* Unit)
	: Model::Unit(Unit)
{
}

Model::Environment::Environment(Manager::Resource* Resource, DWORD Subtype)
	: Model::Unit(0, Resource, Model::ModelEnvironment, Subtype, 1)
{
}

Model::Environment::~Environment()
{
}

Object::IBase* Model::Environment::Copy()
{
	return new Model::Environment(this);
}

void Model::Environment::Parser(XmlTree* Tree)
{
	Environment* l_Unit = new Environment(Manager::Factory::GetResource(Tree->get<std::string>("<xmlattr>.resource")));

	Model::Unit::Parser(l_Unit, Tree);
}

bool Model::Environment::OnAddExtFilter(Object::IElement* Element)
{
	return false;
}