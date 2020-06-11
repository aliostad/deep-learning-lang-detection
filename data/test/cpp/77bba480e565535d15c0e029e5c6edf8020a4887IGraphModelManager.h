#ifndef ED_MODEL_IGRAPH_MODEL_MANAGER_H
#define ED_MODEL_IGRAPH_MODEL_MANAGER_H

namespace model
{

class IGraphModel;

/// Model manager.
class IGraphModelManager
{
protected:
	virtual ~IGraphModelManager() {}
public:
	/// Stored already loaded RootNodes in hash, so you never load one model twice.
	/// This method'll never return NULL. If there is no such model on disk getLoadState returns FAILED_TO_LOAD.
	/// You should set model name without extension.
	virtual IGraphModel* open(const char* fileName)=0;
};
}
#endif
