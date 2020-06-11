#include "multi_gui_model.h"

#include "connection.h"
#include "common/range_algorithm.h"

multi_gui_model::multi_gui_model ()
{

}

multi_gui_model::~multi_gui_model ()
{

}

void multi_gui_model::add_model (gui_model *model)
{
  m_models.push_front (model);
  CONNECT (model, &gui_model::data_changed, this,  &gui_model::data_changed);
}

QVariant multi_gui_model::data (int role) const
{
  for (gui_model *model : m_models)
    {
      if (is_available (model))
       return model->data (role);
    }

  return {};
}

void multi_gui_model::set_model_data (const std::map<int, QVariant> &data_map)
{
  for (gui_model *model : m_models)
    {
      if (!is_available (model))
        continue;

      auto changer = model->do_multi_change ();
      for (auto &&data : data_map)
        changer->set_data (data.first, data.second);

      return;
    }
}

bool multi_gui_model::is_available (gui_model *model) const
{
  return model->data (multi_gui_model_role::AVAILABLE).toBool ();
}

void multi_gui_model::remove_model (gui_model *model)
{
  range::erase (m_models, model);
}
