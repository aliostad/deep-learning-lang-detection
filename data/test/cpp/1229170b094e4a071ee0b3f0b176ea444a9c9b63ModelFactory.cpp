/*
** ModelFactory.cpp for bomberman in /home/vaga/Projects/tek2/bomberman/Graphic
** 
** Made by fabien casters
** Login   <fabien.casters@epitech.eu>
** 
** Started on  Wed May 22 16:47:26 2013 fabien casters
** Last update Wed Jun 05 23:00:30 2013 fabien casters
*/

#include <fstream>
#include <stdexcept>

#include "Model.hpp"
#include "ModelFactory.h"

ModelFactory::ModelFactory() :
    _modelConfig()
{
}

void ModelFactory::init(const std::string &filename)
{
    std::ifstream ifs(filename.c_str());
    if (!ifs.is_open())
        throw std::logic_error("Unable to open file " + filename);

    std::string line;
    while (std::getline(ifs, line))
    {
        modelConfig model;
        std::vector<std::string> elems;
        split(line, ';', elems);
        if (elems.size() < 10)
            continue;

        uint32 modelId = to<uint32>(elems[0].c_str());
        model.nbAnim = addModel(model, elems);
        for (uint32 i = 0; i < model.nbAnim && std::getline(ifs, line); ++i)
        {
            elems.clear();
            split(line, ';', elems);
            if (elems.size() < 3)
                --i;
            else
            {
                animation anim;
                anim.name = elems[0];
                anim.frameBegin = to<uint32>(elems[1].c_str());
                anim.frameEnd = to<uint32>(elems[2].c_str());
                model.elems.push_back(anim);
            }
        }

        gdl::Model::load(model.name);
        _modelConfig[modelId] = model;
    }
    ifs.close();
}

modelConfig ModelFactory::load(uint32 id)
{
    modelConfig model;

    model = _modelConfig[id];
    model.model = new gdl::Model(gdl::Model::load(model.name));
    for (uint32 i = 0; i < model.elems.size(); ++i)
        addAnimation(model, model.elems[i]);

    return model;
}

uint32 ModelFactory::addModel(modelConfig &model, const std::vector<std::string> &elems)
{
    model.name = elems[1];
    model.stackAnim = elems[2];
    model.x = to<float>(elems[3].c_str());
    model.y = to<float>(elems[4].c_str());
    model.z = to<float>(elems[5].c_str());
    model.scaleX = to<float>(elems[6].c_str());
    model.scaleY = to<float>(elems[7].c_str());
    model.scaleZ = to<float>(elems[8].c_str());
    model.model = NULL;
    return to<uint32>(elems[9].c_str());
}

void ModelFactory::addAnimation(modelConfig &model, const animation &anim) const
{
    gdl::Model::cut_animation(*(model.model), model.stackAnim, anim.frameBegin, anim.frameEnd, anim.name);
}
