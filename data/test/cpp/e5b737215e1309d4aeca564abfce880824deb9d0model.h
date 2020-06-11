#ifndef MODEL_H
#define MODEL_H

#include "scenenode.h"


/**
Pure virtual class for describing a model
**/

namespace Hodhr {

  class Shader;
  class SceneNode;

  class Model
  {

  protected:

    Shader* shader;
    bool initialized;

  public:

    // no copy
    //Model(const Model&) = delete;

    // no assign
    //Model& operator=(const Model&) = delete;

    //virtual ~Model() = default;
    virtual ~Model() = 0;

    virtual void init() = 0;
    virtual void draw(const SceneNode& n) = 0;

    virtual void setShader(Shader *s);
  };

}

#endif
