#include "Light.h"
#include <cmath>
#include <cstdlib>
#include <cstdio>

Vector3 Light::sample() {
    if(radius == 0)
        return this->center;

    float x, y;
    x = ((float) (rand()%64)) / 64;
    y = ((float) (rand()%64)) / 64;

    Vector2 sample(x, y);

    return this->center + (sampleToSphere(sample) * radius);
}

Vector3 Light::sampleToSphere(Vector2 sample) {
    double z = 2 * sample.x - 1;
    double t = 2 * 3.14 * sample.y;
    double r = sqrt(1 - z*z);

    return Vector3(r*cos(t), r*sin(t), z);
}
