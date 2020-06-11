#include "iteminsample.h"

ItemInSample::ItemInSample()
{
    changed = false;
    item_id = 0;
    sample_id = 0;
    value = -1;
}
ItemInSample::ItemInSample(const ItemInSample &other)
{
    this->item_id = other.getItemId();
    this->sample_id = other.getSampleId();
    this->value = other.getValue();
    this->changed = other.getChanged();
}

int ItemInSample::getChanged() const
{
    return changed;
}
unsigned int ItemInSample::getItemId() const
{
    return item_id;
}
unsigned int ItemInSample::getSampleId() const
{
    return sample_id;
}
double ItemInSample::getValue() const
{
    return value;
}

void ItemInSample::setChanged(int changed)
{
    this->changed = changed;
}
void ItemInSample::setItemId(unsigned int item_id)
{
    this->item_id = item_id;
}
void ItemInSample::setSampleId(unsigned int sample_id)
{
    this->sample_id = sample_id;
}
void ItemInSample::setValue(double value)
{
    this->value = value;
}
