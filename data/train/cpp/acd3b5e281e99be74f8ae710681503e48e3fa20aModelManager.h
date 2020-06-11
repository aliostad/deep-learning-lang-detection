#pragma once

#include <Engine/Core/Globals.h>
#include <Engine/Model/Model.h>
#include <Engine/Model/ModelAnimationManager.h>

namespace challenge
{
	typedef std::map<std::string, Model *> TModelMap;
	typedef std::vector<Model *> TModelList;

	class ModelManager
	{
	public:
		ModelManager();
		bool Initialize();
		bool LoadModel(std::string modelName, std::string filename);
		void UnloadModel(std::string modelName);

		Model* GetModel(std::string modelName) { return mModels[modelName]; }
		bool IsModelLoaded(std::string modelName) { return mModels.count(modelName); }
		void AddModel(Model *model);
		TModelList GetActiveModels() { return mActiveModels; }

	private:
		TModelMap mModels;
		TModelList mActiveModels;
		ModelAnimationManager *mAnimManager;

		static int s_NextModelId;
	};
};