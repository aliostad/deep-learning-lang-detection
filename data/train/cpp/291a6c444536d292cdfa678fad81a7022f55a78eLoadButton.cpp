#include "Menu/LoadButton.hpp"

namespace Menu
{
  LoadButton::LoadButton()
  {
    this->initAffichage(Data::BG_BUTTON, Data::BG_BUTTON_OVER, Data::BG_BUTTON_CLICKED, this->position_);
  }

  LoadButton::~LoadButton()
  {
  }

  void	LoadButton::init(GameInfo *gameInfo)
  {
    this->gameInfo_ = gameInfo;
  }

  void	LoadButton::update()
  {
  }

  void	LoadButton::action(char)
  {
    if (!this->gameInfo_->load())
      std::cerr << "Error: save file is missing or corrupted !" << std::endl;
    else
      Data::getInstance()->states->push(State::ARCADE);
  }
}
