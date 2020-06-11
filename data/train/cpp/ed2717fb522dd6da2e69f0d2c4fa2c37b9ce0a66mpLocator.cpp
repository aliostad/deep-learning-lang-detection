#include "mpLocator.h"

bool mpLocator::isBounded() const
{
    return true;
}

bool mpLocator::drawLast() const
{
    return true;
}

void mpLocator::drawStyle(M3dView::DisplayStyle style,
                      int drawType , float lw)
{
    if (drawType == 2){
        if ((style == M3dView::kFlatShaded) ||
            (style == M3dView::kGouraudShaded)){
            drawShaded();
        }
        else
            drawWireframe(lw);
    }
    else if (drawType == 1)
        drawShaded();
    else
        drawWireframe(lw);
}
    
void mpLocator::drawShaded()
{
}

void mpLocator::drawWireframe(float lw)
{
}

