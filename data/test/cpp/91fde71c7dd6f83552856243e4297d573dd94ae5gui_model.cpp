#include "gui_model.h"




std::set<int> gui_model::get_change_set (const std::map<int, QVariant> &data_map) const
{
  std::set<int> result;

  for (auto && data_pair : data_map)
    result.insert (data_pair.first);

  return result;
}

gui_model_updater gui_model::do_multi_change ()
{
  return gui_model_updater (this);
}

void gui_model::set_data (int role, QVariant new_data)
{
  gui_model_updater updater (this);
  m_current_changes[role] = new_data;
}

gui_model_updater::gui_model_updater (gui_model *model)
{
  m_model = model;
  m_model->m_changes_counter++;
}

gui_model_updater::~gui_model_updater ()
{
  if (!m_model)
    return;

  m_model->m_changes_counter--;
  if (m_model->m_changes_counter == 0)
  {
    m_model->set_model_data (m_model->m_current_changes);
    m_model->m_current_changes.clear ();
  }
}

gui_model * gui_model_updater::operator-> ()
{
  return m_model;
}
