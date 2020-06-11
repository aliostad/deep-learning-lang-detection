#ifndef MULTI_GUI_MODEL_H
#define MULTI_GUI_MODEL_H

#include "gui_model.h"
#include <deque>

enum multi_gui_model_role : int { AVAILABLE = -1, };

class multi_gui_model : public gui_model
{
  Q_OBJECT

  std::deque<gui_model *> m_models;
public:
  multi_gui_model ();
  ~multi_gui_model ();

  void add_model (gui_model *model);
  void remove_model (gui_model *model);

  virtual QVariant data (int role) const;
  virtual void set_model_data (const std::map<int, QVariant> &data_map);
public:
  bool is_available (gui_model *model) const;

};

#endif // MULTI_GUI_MODEL_H
