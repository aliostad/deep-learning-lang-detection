#pragma once

#include <map>
#include <vector>

#include "defcs.h"

#include "ModelFormat.h"
#include "ModelCE.h"

#include "ModelManager.h"
#include "UserInteractionManager.h"
#include "CameraManager.h"


namespace tema1
{
	class CurvesAndSurfaces
	{
	private:
		manager::ModelManager* model_manager;

		manager::UserInteractionManager* user_interaction_manager;

		manager::CameraManager* camera_manager;


		GLuint model_id = 1;

		std::map<model::CurveType, std::vector<model::ModelFormat*>> models;

		model::ModelFormat* current_model = nullptr;
		model::ModelFormat* previous_model = nullptr;

		

	public:
		CurvesAndSurfaces(manager::ModelManager* model_manager, manager::UserInteractionManager* user_interaction_manager, manager::CameraManager* camera_manager);
		model::ModelFormat* axis_model = nullptr;

		bool isConsistent();
		bool isModelUnderProcessing();

		void startNewModelProcessing(model::CurveType curve_type);
		void insertPoint(glm::vec3 point);
		bool canActivateEditing();
		void endModelProcessing();

		void increaseCurvesNo();
		void decreaseCurvesNo();

		void updateCurvePointsNo(GLint no);

		void addAxisModel();
		model::ModelFormat* getAxisModel();
		void setCurrentModel(model::ModelFormat*);
		void setModelTransformation(GLuint transformation_id);

		void clean();
		void resendModelToManager(model::ModelFormat* model);
		void resendCurrentModelToManager();

		std::map<model::CurveType, std::vector<model::ModelFormat*>>& getModels();
		void printCurrentModelInfo();
	};
}