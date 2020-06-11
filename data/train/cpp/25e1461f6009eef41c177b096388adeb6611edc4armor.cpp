#include "armor.hpp"

namespace mekton {

Armor::Armor( Model a_model ) : m_model(a_model) {
	update();
}

void Armor::update()
{
	m_cost = static_cast<float>(m_model.value);
	m_stopping_power = m_model.value;
	m_weight = m_cost/2.f;
}

Model Armor::model() const
{
    return m_model;
}

void Armor::model( const Model& a_model )
{
	m_model = a_model;
	update();
}

decimal Armor::cost() const
{
    return m_cost;
}

decimal Armor::weight() const
{
    return m_weight;
}

std::uint32_t Armor::stopping_power() const
{
    return m_stopping_power;
}

}
