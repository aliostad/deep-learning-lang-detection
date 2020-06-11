#pragma once

#include "Context.h"
#include "Item.h"
#include "Anima_nsbegin.h"


class Model;
class Clip;
class ClipLink;
class ModelClipFootInfo;
//class GfxModel;
class BaseModel;

class ANIMA_CORE_API ModelLibrary  : public BObject
{
private:

	QMap<QString,BaseModel *> baseModelList;

	QList<Model *> guiModelList;
	QList<Model *> fullModelList;
	QList<QString> categoryList;

	
public:
	ModelLibrary(void);
	virtual ~ModelLibrary(void);

	QList<Model *> &GUIModelList(){return guiModelList;}
	QList<Model *> &FullModelList(){return fullModelList;}
	void FindModels(const QString &category,QList<Model *> &models,bool onlyGUI);
	void GetBaseModelList(QList<BaseModel *> &list);
	QList<QString> &GetCategoryList(){return categoryList;}

	void Load();
	void Save(Model *model,const QString &clipID );
	void Init();

	BaseModel *GetBaseModel(const QString &name);
	Model *GetDefaultModel();

	QString GetBaseModelDefinePath(Model *model);
	QString GetModelPath(Model *model);
	QString GetModelName(Model *model);
	QString GetModelSkeletonPath(Model *model);
	QString GetModelDir(Model *model);
	QString GetModelRenderDir(Model *model);
	QString GetModelDefinePath(Model *model);
	QString GetModelPrebuildPath(Model *model);

	Model *Find(const QString &name);

	// STUDIO API
	void AddModel(Model *model);
	void DeleteModel(Model *model);
	bool RenameModel(Model *model,const QString &newName);
	void RebuildCategories();

	void ReloadClipBlend();
	bool HaveGeomModel(Model *model);
};
#include "Anima_nsend.h"
