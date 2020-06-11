#ifndef _MODEL_H_
# define _MODEL_H_

# include <string>
# include <stdexcept>
# include <Model.hh>

# include "Model.hpp"
# include "AObject.hpp"
# include "ResourceManager.hpp"
# include "AResource.hpp"

class Model : public gdl::Model, public AResource
{
public:
  Model(const std::string &path);
  virtual ~Model() {};
};

class GameModel : public AObject
{
public:
  GameModel(const SharedPointer<Model>& mod);
  GameModel(const std::string& path);
  virtual ~GameModel() {};

  virtual void draw(gdl::AShader *shader, const gdl::Clock& clock);

  Model* operator->() const;

private:
  SharedPointer<Model> _model;
};

#endif /* _MODEL_H_ */
