#include "world3/world.h"
#include "model/model.h"

using namespace std;

Model* loadModel(const char *name)
{
  Model * model = 0;
  ifstream inStream;
  inStream.open(name, ios::in);
  if (!inStream.fail())
  {
    model = new Model();
    model->load(inStream);
  }
  return model;
}

int main(int argc, char* argv[])
{
  theWorld.initialize("First World", 800,600);

  Model *model = loadModel("model.obj");
  if (!model)
  {
    cerr << "Cannot find model file. Aborting ...\n";
    return 1;
  }

  theWorld.renderables = &model->entities;

  theWorld.start();
  return 0;
}
