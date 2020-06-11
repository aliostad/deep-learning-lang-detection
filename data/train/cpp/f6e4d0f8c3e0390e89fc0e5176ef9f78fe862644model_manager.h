#ifndef BOUNCE_RENDERER_MODEL_MANAGER_H_
#define BOUNCE_RENDERER_MODEL_MANAGER_H_

#include "framework/object_cache.h"
#include "model.h"

namespace bounce {
    
    class ModelManager {
    private:
        ObjectCache<Model> models_;
        
        ModelManager(const ModelManager&) = delete;
        ModelManager& operator=(const ModelManager&) = delete;
        
    public:
        ModelManager();
        ~ModelManager();
        
        unsigned int GenerateModel();
        
        Model& GetModel(unsigned int model_handle);
        const Model& GetModel(unsigned int model_handle) const;
    };
    
}

#endif // BOUNCE_RENDERER_MODEL_MANAGER_H_
