#include "Model.h"


extern "C" {
	Oni_ModelPtr Oni_Model_new(){
		Oni::Model* model = new Oni::Model();
		
		return (Oni_ModelPtr)model;
	}

	void Oni_Model_delete(Oni_ModelPtr obj){
		printf("======DELETING MODEL\n");
		Oni::Model* model = (Oni::Model*)(obj);
		
		delete model;
	}

	void Oni_Model_markgc(Oni_ModelPtr obj){
		printf("======MARK FOR COLLECTION\n");
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->setVisible(false);
	}

	void Oni_Model_initialize(Oni_ModelPtr obj, Ogre_WindowPtr obj2, char* name, char* filename, Ogre_NodePtr parent){
		Oni::Model* model = (Oni::Model*)(obj);
		GameApplication* game = (GameApplication*)obj2;
		
		std::string cpp_name(name);
		std::string cpp_filename(filename);
		
		Ogre::Node* parentNode = (Ogre::Node*)(parent);
		
		model->initialize(game->getSceneMgr(), cpp_name, cpp_filename, parentNode);
	}

	void Oni_Model_update(Oni_ModelPtr obj, double dt){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->update(dt);
	}
	
	// TODO: Check for potential memory leak
	const char* Oni_Model_getName(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		return model->getName().c_str();
	}
	
	Ogre_NodePtr Oni_Model_getParentNode(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		Ogre::Node* node = model->getEntity()->getParentNode();
		return (Ogre_NodePtr)(node);
	}
	
	void Oni_Model_attachObjectToBone(Oni_ModelPtr obj, char* name, Oni_ModelPtr obj2){
		Oni::Model* model = (Oni::Model*)(obj);
		Oni::Model* otherModel = (Oni::Model*)(obj2);
		
		std::string cpp_name(name);
		model->attachObjectToBone(cpp_name, otherModel);
	}
	
	void Oni_Model_detachObjectFromBone(Oni_ModelPtr obj, Oni_ModelPtr obj2){
		Oni::Model* model = (Oni::Model*)(obj);
		Oni::Model* otherModel = (Oni::Model*)(obj2);
		
		model->detachObjectFromBone(otherModel);
	}
	
	int Oni_Model_isAttachedToBone(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		if(model->isAttachedToBone())
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	
	double Oni_Model_getBoundingBoxWidth(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		return model->getBoundingBoxWidth();
	}
	
	double Oni_Model_getBoundingBoxDepth(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		return model->getBoundingBoxDepth();
	}
	
	double Oni_Model_getBoundingBoxHeight(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		return model->getBoundingBoxHeight();
	}

	int Oni_Model_getVisible(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		if(model->getVisible())
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	
	void Oni_Model_setVisible(Oni_ModelPtr obj, int visible){
		Oni::Model* model = (Oni::Model*)(obj);
		
		if(visible)
		{
			model->setVisible(true);
		}
		else
		{
			model->setVisible(false);
		}
	}
	
	int Oni_Model_getCastShadows(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		if(model->getCastShadows()){
			return 1;
		}
		else{
			return 0;
		}
	}
	
	void Oni_Model_setCastShadows(Oni_ModelPtr obj, int enabled){
		Oni::Model* model = (Oni::Model*)(obj);
		
		if(enabled){
			model->setCastShadows(true);
		}
		else{
			model->setCastShadows(false);
		}
	}
	
	void Oni_Model_getPosition(Oni_ModelPtr obj, double* vector){
		Oni::Model* model = (Oni::Model*)(obj);
		
		Ogre::Vector3 position = model->getPosition();
		
		vector[0] = position.x;
		vector[1] = position.y;
		vector[2] = position.z;
	}
	
	void Oni_Model_setPosition(Oni_ModelPtr obj, double x, double y, double z){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->setPosition(x,y,z);
	}
	
	void Oni_Model_translate(Oni_ModelPtr obj, double x, double y, double z, OniTransformSpace ts){
		// void translate(Ogre::Real x, Ogre::Real y, Ogre::Real z, Ogre::Node::TransformSpace relativeTo=Ogre::Node::TS_PARENT);
		Oni::Model* model = (Oni::Model*)(obj);
		
		switch(ts){
			case LOCAL:
				model->translate(x,y,z, Ogre::Node::TS_LOCAL);
				break;
			case PARENT:
				model->translate(x,y,z, Ogre::Node::TS_PARENT);
				break;
			case WORLD:
				model->translate(x,y,z, Ogre::Node::TS_WORLD);
				break;
		}
	}
	
	void Oni_Model_scale(Oni_ModelPtr obj, double x, double y, double z){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->scale(x,y,z);
	}
	
	void Oni_Model_getScale(Oni_ModelPtr obj, double* vector){
		Oni::Model* model = (Oni::Model*)(obj);
		
		Ogre::Vector3 scale = model->getScale();
		
		vector[0] = scale.x;
		vector[1] = scale.y;
		vector[2] = scale.z;
	}
	
	void Oni_Model_setScale(Oni_ModelPtr obj, double x, double y, double z){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->setScale(x,y,z);
	}
	
	void Oni_Model_resetOrientation(Oni_ModelPtr obj)
	{
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->resetOrientation();
	}
	
	void Oni_Model_setOrientation(Oni_ModelPtr obj, double w, double x, double y, double z)
	{
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->setOrientation(w,x,y,z);
	}
	
	void Oni_Model_rotate(Oni_ModelPtr obj, double w, double x, double y, double z)
	{
		Oni::Model* model = (Oni::Model*)(obj);
		
		Ogre::Quaternion quat = Ogre::Quaternion(w,x,y,z);
		model->rotate(quat);
	}
	
	void Oni_Model_pitch(Oni_ModelPtr obj, double radians){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->pitch(Ogre::Radian(radians));
	}
	
	void Oni_Model_yaw(Oni_ModelPtr obj, double radians){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->yaw(Ogre::Radian(radians));
	}
	
	void Oni_Model_roll(Oni_ModelPtr obj, double radians){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->roll(Ogre::Radian(radians));
	}
	
	
	// Rotate to face the given vector - DEPRECIATED
	void Oni_Model_rotateTo(Oni_ModelPtr obj, double x, double y, double z){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->rotateTo(x,y,z);
	}
	
	
	// Set rotation in horizontal plane
	void Oni_Model_setRotation(Oni_ModelPtr obj, double radians){
		Oni::Model* model = (Oni::Model*)(obj);
		
		model->setHorizontalPlaneRotation(Ogre::Radian(radians));
	}
	
	double Oni_Model_getRotation(Oni_ModelPtr obj){
		Oni::Model* model = (Oni::Model*)(obj);
		
		return model->getHorizontalPlaneRotation().valueRadians();
	}
	
}