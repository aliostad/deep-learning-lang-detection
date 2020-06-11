//
// ModelInstance.h
//

#include "Common.h"

class ModelInstance
{
public:
    friend class Scene;

    ModelInstance()
    {
        _model = NULL;
        _parent = NULL;
    }
    void AddChild(ModelInstance *child)
    {
        _children.push_back(child);
    }
    void Render();

private:
    Model *_model;
    
    ModelInstance *_parent;
    std::vector<ModelInstance*> _children;

    Matrix4 _transform;

    Vec3f _parentContactPosition;
    Vec3f _parentContactNormal;
    Vec3f _parentOffset;
};
