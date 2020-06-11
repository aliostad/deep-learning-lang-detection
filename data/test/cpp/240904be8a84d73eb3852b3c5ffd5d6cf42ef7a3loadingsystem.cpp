#include <iostream>
#include <signal.h>
#include "loadingsystem.h"
#include "statisticsio.h"

LoadingSystem::LoadingSystem(Repository *repo)
{
	sf::Font *font = new sf::Font();

	if (!font->loadFromFile("visitor1.ttf"))
	{
		std::cout << "CANNOT OPEN FONT FILE" << std::endl;
		raise(SIGABRT);
	}

	_font = font;
    _repo = repo;
	_name = SYS_LOADING;
}

void LoadingSystem::update()
{
	ObjectList::iterator i = _repo->beginGroup(GRP_GAMESTATE);
	GameObject *o = *i;
	StatisticsIO *file = new StatisticsIO("scores.txt");

	if (o->get(ATTR_GAMESTATE, "load").toBool()) {
		switch (o->get(ATTR_GAMESTATE, "inGame").toBool()) {
			case false:
				_repo->clean();
				_repo->newMenuObject(230, 20, 100, 0, false, false, false, _font, "SODIUM", this);
				_repo->newMenuObject(250, 90, 100, 0, false, false, false, _font, "EDGE", this);
				_repo->newMenuObject(50, 500, 50, 0, false, false, false, _font, "Player1: ", this);
				_repo->newMenuObject(450, 500, 50, 0, false, false, false, _font, "Player2: ", this);
				_repo->newMenuObject(270, 500, 50, 0, false, false, true, _font, std::to_string(file->getPlayerOneScore()), this);
				_repo->newMenuObject(685, 500, 50, 0, false, false, true, _font, std::to_string(file->getPlayerTwoScore()), this);
				_repo->newMenuObject(300, 300, 30, 1, true, true, false, _font, "START GAME", this);
				_repo->newMenuObject(300, 330, 30, 2, true, false, false, _font, "CLEAR WINS", this);
				_repo->newMenuActionObject(this);
				_repo->newGameStateObject(false, false, this);

				break;

			case true:		
				_repo->clean();
				_repo->newMenuObject(20, 30, 20, 1, false, false, false, _font, "press R to menu", this);
				_repo->newMenuObject(285,40, 50, 1, false, false, false, _font, "P1 vs P2", this);
				_repo->newMenuObject(350,80, 50, 2, true, false, true, _font, "0", this);
				_repo->newMenuObject(390,80, 50, 1, false, false, false, _font, "\:", this);
				_repo->newMenuObject(410,80, 50, 1, true, false, true, _font, "0", this);
				_repo->newPlatformObject(100, 500, 600, 100, this);
				_repo->newSwordObject(150, 440, 50, 9, 1, this);
				_repo->newPlayerObject(120, 400, 30, 100, 1, sf::Keyboard::W,
																sf::Keyboard::S,
																sf::Keyboard::A,
																sf::Keyboard::D,
																sf::Keyboard::LShift,
																sf::Keyboard::LControl,
																sf::Keyboard::R,
																this);
				_repo->newSwordObject(600, 440, 50, 9, 2, this);
				_repo->newPlayerObject(650, 400, 30, 100, 2, sf::Keyboard::Up,
																sf::Keyboard::Down,
																sf::Keyboard::Left,
																sf::Keyboard::Right,
																sf::Keyboard::RShift,
																sf::Keyboard::RControl,
																sf::Keyboard::R,
																this);
				_repo->newRefereeObject(this);
				_repo->newGameStateObject(true, false, this);

				break;
		}
	}
}