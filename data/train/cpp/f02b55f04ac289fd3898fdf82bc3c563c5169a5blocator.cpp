#include "gtest/gtest.h"

#include "dioptre/locator.h"
#include "dioptre/module.h"
#include "dioptre/window/window_interface.h"
#include "dioptre/graphics/graphics_interface.h"
#include "dioptre/keyboard/keyboard_interface.h"
#include "dioptre/mouse/mouse_interface.h"
#include "dioptre/time/time_interface.h"
#include "dioptre/physics/physics_interface.h"
#include "dioptre/ai/ai_interface.h"

using dioptre::window::WindowInterface;
using dioptre::graphics::GraphicsInterface;
using dioptre::keyboard::KeyboardInterface;
using dioptre::mouse::MouseInterface;
using dioptre::time::TimeInterface;
using dioptre::physics::PhysicsInterface;
using dioptre::ai::AIInterface;

TEST(Locator, DefaultWindow) {
  dioptre::Locator::initialize();
  WindowInterface *window =
      dioptre::Locator::getInstance<WindowInterface>(dioptre::Module::M_WINDOW);

  EXPECT_EQ(window->initialize(), 0);
}

TEST(Locator, DefaultGraphics) {
  dioptre::Locator::initialize();
  GraphicsInterface *graphics =
      dioptre::Locator::getInstance<GraphicsInterface>(
          dioptre::Module::M_GRAPHICS);

  EXPECT_EQ(graphics->initialize(), 0);
}

TEST(Locator, DefaultKeyboard) {
  dioptre::Locator::initialize();
  KeyboardInterface *keyboard =
      dioptre::Locator::getInstance<KeyboardInterface>(
          dioptre::Module::M_KEYBOARD);

  EXPECT_EQ(keyboard->initialize(), 0);
}

TEST(Locator, DefaultMouse) {
  dioptre::Locator::initialize();
  MouseInterface *mouse =
      dioptre::Locator::getInstance<MouseInterface>(dioptre::Module::M_MOUSE);

  EXPECT_EQ(mouse->initialize(), 0);
}

TEST(Locator, DefaultTime) {
  dioptre::Locator::initialize();
  TimeInterface *time =
      dioptre::Locator::getInstance<TimeInterface>(dioptre::Module::M_TIME);

  EXPECT_EQ(time->initialize(), 0);
}

TEST(Locator, DefaultPhysics) {
  dioptre::Locator::initialize();
  PhysicsInterface *physics = dioptre::Locator::getInstance<PhysicsInterface>(
      dioptre::Module::M_PHYSICS);

  EXPECT_EQ(physics->initialize(), 0);
}

TEST(Locator, DefaultAI) {
  dioptre::Locator::initialize();
  AIInterface *ai =
      dioptre::Locator::getInstance<AIInterface>(dioptre::Module::M_AI);

  EXPECT_EQ(ai->initialize(), 0);
}

class MockGraphics : public GraphicsInterface {
public:
  int initialize() { return 1337; }
  void resize(int width, int height) {}
  void render(const double alpha) {}
  void destroy() {}
  void destroyScene(dioptre::graphics::Scene *scene) {}
  void initializeScene() {}
};

TEST(Locator, Provide) {
  dioptre::Locator::initialize();

  MockGraphics *mockGraphics = new MockGraphics();
  dioptre::Locator::provide(dioptre::Module::M_GRAPHICS, mockGraphics);

  EXPECT_EQ(dioptre::Locator::getInstance<GraphicsInterface>(
                dioptre::Module::M_GRAPHICS),
            mockGraphics);
}

TEST(Locator, ProvideNull) {
  dioptre::Locator::initialize();
  auto nullGraphics = dioptre::Locator::getInstance<GraphicsInterface>(
      dioptre::Module::M_GRAPHICS);

  MockGraphics *mockGraphics = new MockGraphics();
  dioptre::Locator::provide(dioptre::Module::M_GRAPHICS, mockGraphics);
  dioptre::Locator::provide(dioptre::Module::M_GRAPHICS, nullptr);

  // Setting it to nullptr does revert back to default
  EXPECT_EQ(dioptre::Locator::getInstance<GraphicsInterface>(
                dioptre::Module::M_GRAPHICS),
            nullGraphics);
}
