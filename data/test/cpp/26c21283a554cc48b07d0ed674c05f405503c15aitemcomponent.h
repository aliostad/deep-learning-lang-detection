#ifndef MODEL_ITEMCOMPONENT_H
#define MODEL_ITEMCOMPONENT_H

#include "item.h"
#include "MangoModel_global.h"
#include "component.h"

namespace Model {

class MANGOMODELSHARED_EXPORT ItemComponent
{
public:
    ItemComponent(int id);
    ItemComponent(int id, Model::Item item, Model::Component component);

    int id() const;
    Model::Item item() const;
    Model::Component component() const;

    void setItem(Model::Item item);
    void setComponent(Model::Component component);

private:
    int m_id;
    Model::Item m_item;
    Model::Component m_component;
};

}

#endif // MODEL_ITEMCOMPONENT_H
