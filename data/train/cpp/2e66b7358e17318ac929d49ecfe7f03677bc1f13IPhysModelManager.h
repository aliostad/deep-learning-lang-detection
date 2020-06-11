#ifndef ED_MODEL_IPHYS_MODEL_MANAGER_H
#define ED_MODEL_IPHYS_MODEL_MANAGER_H

namespace model
{

class IPhysModel;

/// Model manager.
class IPhysModelManager
{
protected:
	virtual ~IPhysModelManager() {}
public:
	/// Stored already loaded RootNodes in hash, so you never load one model twice.
	/// This method'll never return NULL. If there is no such model on disk getLoadState returns FAILED_TO_LOAD.
	/// You should set model name without extension.
	virtual IPhysModel* open(const char* fileName)=0;
};
}
#endif
