#include "LoadState.h"
#include "PlayState.h"

#include <thread>
#include <stdlib.h>
#include <cstdlib>

LoadState::LoadState(ALLEGRO_DISPLAY* display) : ScreenState(display) {
	
}


LoadState::~LoadState(){
}

void LoadState::loadManager(Game *game){
	game->setManager(new ResourceManager());

} 

void LoadState::start(Game *game, ScreenState *previous){
	
}

void LoadState::end(Game *game){
	
}

void LoadState::tick(double deltaTime){
	al_clear_to_color(al_map_rgb(50, 0, 0));
	loadManager(Game::get());

	Game::get()->setScreenState(new PlayState(getDisplay()));
}

void LoadState::handleKeyboard(ALLEGRO_EVENT_TYPE type, int keycode){

}

void LoadState::handleMouse(ALLEGRO_EVENT_TYPE type, ALLEGRO_MOUSE_STATE state){

}
