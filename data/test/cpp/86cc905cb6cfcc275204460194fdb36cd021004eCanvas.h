#include "Sample.h"

class Canvas {
  public:
    static Sample currSample;
    float width;
    float height;
    Canvas() {
    }
    Canvas(float width, float height) :
    width(width),
    height(height)
    {
    }
    static Sample getCurrSample();
    bool getSample(Sample* sample);
};

Sample Canvas::getCurrSample() {
  return Sample(currSample.x, currSample.y);
}

bool Canvas::getSample(Sample* sample) {
  if (sample->x == (width - 1) && sample->y == (height - 1)) {
    return false;
  }
  if (sample->x == (width - 1)) {
    currSample.x = 0;
    currSample.y++;
    return true;
  }
  currSample.x++;
  return true;
}

Sample Canvas::currSample = Sample(0,0);
