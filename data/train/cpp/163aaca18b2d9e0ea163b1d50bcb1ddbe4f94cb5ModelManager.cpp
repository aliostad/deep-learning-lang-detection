#include "ModelManager.h"
#include <Independent/File/FileSystem.h>


Miracle::ModelManager::ModelManager()
{
}


Miracle::ModelManager::~ModelManager()
{
}

Miracle::Model* Miracle::ModelManager::Load(const HName& a_Name)
{
	Model* model = nullptr;
	Find(a_Name, model);
	if (model == nullptr)
	{
		model = FileSystem::GetInstance()->LoadModel(a_Name.GetString());
		if (model != nullptr)
		{
			m_Mananger.Insert(a_Name, model);
			return model;
		}
		else
		{
			return nullptr;
		}
	}
	return model;
}

bool Miracle::ModelManager::Find(const HName& a_Name, Model*& a_Image)
{
	auto node = m_Mananger.Find(a_Name);
	if (node == nullptr)
	{
		return false;
	}
	a_Image = node->Value;
	return true;
}
