#ifndef __SMART_MODEL_H__
#define __SMART_MODEL_H__

#include "common.h"
#include "core/CoreModel.h"
#include "Builder.h"

namespace smart {
// -------------------------------------------------------------------------- //
// Model
// -------------------------------------------------------------------------- //
  class Model {
  public:
    template<PrimitiveType type> 
    Builder<type> newPrimitive() {
      return Builder<type>(mModel);
    }

    Builder<> newPrimitive(int type) {
      return Builder<SMART_DYNAMIC>(mModel, type);
    }

    void compile() {
      mModel->compile();
    }

  private:
    friend class Smart;
    friend class Scene;

    Model(CoreModel* model): mModel(model) {}

    CoreModel* mModel;
  };

} // namespace smart

#endif // __SMART_MODEL_H__
