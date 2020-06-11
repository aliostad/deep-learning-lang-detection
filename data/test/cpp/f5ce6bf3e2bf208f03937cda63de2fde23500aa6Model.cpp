#include "Model.hpp"

Model::Model(const std::string &path)
  : AResource::AResource(path)
{
  if (load(path) == false)
    throw std::runtime_error("Can't load model : " + path);
}

GameModel::GameModel(const SharedPointer<Model>& mod)
  : _model(mod)
{

}

GameModel::GameModel(const std::string& path)
  : _model(MediaManager::getInstance()->loadMediaFromFile<Model>(path))
{

}

void GameModel::draw(gdl::AShader *shader, const gdl::Clock& clock)
{
  _model->draw(*shader, getTransformation(), clock.getElapsed());
}

Model* GameModel::operator->() const
{
  return _model.ptr();
}
