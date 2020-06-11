#include "locator.hpp"

using namespace boost;

void Locator::init ()
{
    Locator::graphics_.reset(new Graphics());
    Locator::resources_.reset(new Resources());
}

void Locator::setGraphics (Graphics& graphics)
{
    Locator::graphics_.reset(&graphics);
}

void Locator::setResources (Resources& resources)
{
    Locator::resources_.reset(&resources);
}

Graphics& Locator::graphics ()
{
    if ( Locator::graphics_ == NULL )
    {
        Locator::init();
    }

    return *Locator::graphics_;
}

Resources& Locator::resources ()
{
    if ( Locator::resources_ == NULL )
    {
        Locator::init();
    }

    return *Locator::resources_;
}

scoped_ptr<Graphics> Locator::graphics_;
scoped_ptr<Resources> Locator::resources_;
