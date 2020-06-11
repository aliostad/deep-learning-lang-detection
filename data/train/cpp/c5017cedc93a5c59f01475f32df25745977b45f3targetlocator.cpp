#include "targetlocator.h"
#include "webdriverhub.h"
#include "webelement.h"

void TargetLocator::frame(QString id)
{
    m_hub->changeFrame(id);
}

void TargetLocator::frame(int id)
{
    m_hub->changeFrame(id);
}

void TargetLocator::frame(WebElement* element)
{
    QJsonObject json;
    json["ELEMENT"] = element->id();

    m_hub->changeFrame(json);
}

void TargetLocator::parentFrame()
{
    m_hub->changeFrameParent();
}

void TargetLocator::defaultContent()
{
    m_hub->changeFrame();
}

void TargetLocator::window(QString handle)
{
    m_hub->changeWindow(handle);
}

WebElement* TargetLocator::activeElement()
{
    QString id = m_hub->getElementActive();
    return new WebElement(id, m_hub);
}

Alert* TargetLocator::alert()
{
    return new Alert(m_hub);
}
