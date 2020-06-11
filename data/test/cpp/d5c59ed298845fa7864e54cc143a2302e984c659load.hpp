#ifndef LOAD_HPP
#define LOAD_HPP

  #include <string>
  #include <iostream>
  #include <vector>
  #include <algorithm>
  #include <unistd.h>
  #include <dirent.h>
  #include <SDL/SDL.h>
  #include <SDL/SDL_ttf.h>
  #include "input.hpp"
  #include "c8y_state.hpp"
  #include "c8y_media.hpp"


  /* Normal functions */
  void load_init();
  void load_close();
  void load_activate();
  void load_update();
  void load_draw();
  C8Y_STATE load_target_state();


  /* Special functions */
  bool load_new_rom_selected();
  std::string load_new_rom_name();


#endif
