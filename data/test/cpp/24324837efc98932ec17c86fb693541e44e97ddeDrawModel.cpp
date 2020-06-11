#include "DrawModel.hh"
#include "ConfigLoader.hpp"
#include <iostream>

std::map<std::string, DrawModel*> DrawModel::_mapModel;

DrawModel::DrawModel()
{
}

DrawModel::~DrawModel()
{}

void			DrawModel::initialize()
{
  _mapModel["Bomberman"] = new DrawModel();
  _mapModel["Bomb"] = new DrawModel();
  _mapModel["Bomb"]->charge("Bomb");
  _mapModel["Bomberman"]->charge("Bomberman");

  _mapModel["TP"] = new DrawModel();
  _mapModel["TP"]->charge("TP");
}

glm::vec3&		DrawModel::getRatio()
{
  return _ratio;
}

gdl::Model&		 DrawModel::getModel()
{
  return _model;
}

DrawModel*	DrawModel::getDrawModel(std::string const& str)
{
  DrawModel* DC;
  DC = new DrawModel();
  try
    {
      DC->charge(str);
    }
  catch (ConfigLoader::Exception &e)
    {
      std::cout << e.what() << std::endl;
    }
  return (DC);
}

void	DrawModel::charge(const std::string &str)
{
  float	ratio;
  std::string model;

  ConfigLoader::getVarValue("animations", str + std::string("_ratio"), ratio);
  ConfigLoader::getVarValue("animations", str + std::string("_model"), model);
  _model.load(model);
  _ratio = glm::vec3(ratio, ratio, ratio);
  if (ConfigLoader::keyExist("animations", str))
    {
      applyAnimation(str, "standing");
      applyAnimation(str, "stand_run");
      applyAnimation(str, "running");
    }
}

void	DrawModel::applyAnimation(const std::string &model, const std::string &str)
{
  std::string	anim;
  int		frames[2];

  ConfigLoader::getVarValue("animations", model + std::string("_") + str, anim);
  ConfigLoader::getVarValue("animations", model + std::string("_start_") + str, frames[0]);
  ConfigLoader::getVarValue("animations", model + std::string("_stop_") + str, frames[1]);
  _model.createSubAnim(0, anim, frames[0], frames[1]);
}
