// -----------------------------------------------------------------------------
//  Author: Howard Hughes
//
//  Function for loading factories into the engine
//
//  Copyright (C) 2015 DigiPen Institute of Technology.
//  Reproduction or disclosure of this file or its contents without
//  the prior written consent of DigiPen Institute of Technology is
//  prohibited.
// -----------------------------------------------------------------------------

#include "../KeplerCore/load_factories.h"
#include "../GraphicsComponents/load_factories.h"
#include "../AudioEngine/load_factories.h"
#include "../ComponentSandbox/load_factories.h"
#include "../PhysicsComponents/load_factories.h"
#include "../AwesomiumComponents/load_factories.h"
#include "../InputComponent/load_factories.h"
#include "../DebugDrawComponents/load_factories.h"
#include "../EditorComponents/load_factories.h"

void InitComponents()
{
  KeplerCore::LoadFactories();
  GraphicsComponents::LoadFactories();
  AudioInit::LoadFactories();
  InputInit::LoadFactories();
  ComponentSandbox::LoadFactories();
  PhysicsComponents::LoadFactories();
  AwesomiumComponents::LoadFactories();
  DebugDrawComponents::LoadFactories();
  EditorComponents::LoadFactories();
}
