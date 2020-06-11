#ifndef _MODELS_INIT_HPP
#define _MODELS_INIT_HPP

#include "game.hpp"
#include "load_model.hpp"
#include "load_light.hpp"
#include "load_sprite.hpp"

_NAMESPACE_GAME_MODELS


extern void cleanModelsStore();

extern void loadModels(const std::string &fname);
extern void loadLights(const std::string &fname);
extern void loadSprites(const std::string &fname);

extern void _load(const std::string &fname,
                  t_load_command_callback load_command_callback,
                  t_clear_load_callback clear_load_callback);


_END_NAMESPACE

#endif  // _MODELS_INIT_HPP
