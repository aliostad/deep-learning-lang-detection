#ifndef MODEL_RENDERER_HPP_
#define MODEL_RENDERER_HPP_

#include "../config.hpp"
#include "../math.hpp"
#include "graphics/ogl.hpp"
#include <vector>

namespace MODEL
{

struct Model
{
  GLuint listid;

  Model() :
    listid(0)
  { }
};

extern GLuint load_model_displaylist(std::vector<math::Vec3f>& verts, std::vector<math::Vec3f>& norms, std::vector<unsigned int>& iverts, std::vector<unsigned int>& inorms);
extern void draw_model(Model *model);
extern void free_model_list(Model *model);

}

#endif // MODEL_RENDERER_HPP_
