#include "Sample.h"



Sample::Sample () {x=0;y=0;}
    Sample::Sample (float sx, float sy){
        x=sx;
        y=sy;
    }
    float Sample::getX(void) {
        return x;
    }
    float Sample::getY(void) {
        return y;
    }
int Sample::getintX(void) {
    return (int) x;
}
int Sample::getintY(void) {
    return (int) y;
}
    void Sample::setX(float newx) {
        x=newx;
    }
    void Sample::setY(float newy) {
        y=newy;
    }

    bool Sample::equals(Sample* p) {
        return x == p->getX() && y == p->getY();
    }