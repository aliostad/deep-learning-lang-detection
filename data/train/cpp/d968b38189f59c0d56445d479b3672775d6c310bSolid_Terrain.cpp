//
//  Solid_Terrain.cpp
//  game
//
//  Created by Donald Clark on 10/30/13.
//
//

#include "Solid_Terrain.h"

using namespace Zeni;
using namespace Zeni::Collision;
using std::map;
using std::make_pair;
using std::pair;
using std::bad_exception;

Solid_Terrain::Model_Manager
Solid_Terrain::model_manager = Solid_Terrain::Model_Manager();

Solid_Terrain::Solid_Terrain(const String &model_,
                             const Point3f &corner_,
                             const Vector3f &scale_,
                             const Quaternion &rotation_)
: Terrain(corner_, scale_, rotation_),
  model(model_)
{
  if (!model_manager.find_model(model_)) model_manager.load_model(model_);
  else model_manager.increment_instance_count(model_);
  create_body();
}

Solid_Terrain::Solid_Terrain(const Solid_Terrain &rhs)
: Terrain(rhs.get_corner(),
          rhs.get_scale(),
          rhs.get_rotation())
{
  if (model != rhs.get_model()) throw new bad_exception;
  model_manager.increment_instance_count(model);
  create_body();
}

Solid_Terrain & Solid_Terrain::operator=(const Solid_Terrain &rhs) {
  if (model != rhs.get_model()) throw new bad_exception;
  set_corner(rhs.get_corner());
  set_scale(rhs.get_scale());
  set_rotation(rhs.get_rotation());
  create_body();
  return *this;
}

Solid_Terrain::~Solid_Terrain() {
  model_manager.decrement_instance_count(model);
}

void Solid_Terrain::render() {
  const std::pair<Vector3f, float> cur_rotation = get_rotation().get_rotation();
  Model* model_ptr = model_manager.get_model(model);
  model_ptr->set_translate(get_corner());
  model_ptr->set_scale(get_scale());
  model_ptr->set_rotate(cur_rotation.second, cur_rotation.first);
  model_ptr->render();
}

Solid_Terrain::Model_Manager::Model_Manager() {}

Solid_Terrain::Model_Manager::~Model_Manager() {
  for (auto it = model_map.begin(); it != model_map.end();) {
    if (it->second.first != nullptr) delete it->second.first;
    else ++it;
  }
}

bool Solid_Terrain::Model_Manager::find_model(const String &model_) const {
  return model_map.find(model_) != model_map.end();
}

Model * Solid_Terrain::Model_Manager::get_model(const String &model_) {
  map<String, pair<Model*, unsigned long> >::iterator it;
  if ((it = model_map.find(model_)) == model_map.end()) throw new bad_exception;
  return it->second.first;
}

void Solid_Terrain::Model_Manager::load_model(const String &model_) {
  if (find_model(model_)) throw new bad_exception;
  model_map[model_] = make_pair(new Model(model_), 1lu);
}

const unsigned long & Solid_Terrain::Model_Manager::get_instance_count(const String &model_) const {
  map<String, pair<Model*, unsigned long> >::const_iterator it;
  if ((it = model_map.find(model_)) == model_map.end()) throw new bad_exception;
  return it->second.second;
}

void Solid_Terrain::Model_Manager::decrement_instance_count(const String &model_) {
  map<String, pair<Model*, unsigned long> >::iterator it;
  if ((it = model_map.find(model_)) == model_map.end()) throw new bad_exception;
  if (!--it->second.second) {
    delete it->second.first;
    model_map.erase(it);
  }
}

void Solid_Terrain::Model_Manager::increment_instance_count(const String &model_) {
  map<String, pair<Model*, unsigned long> >::iterator it;
  if ((it = model_map.find(model_)) == model_map.end()) throw new bad_exception;
  it->second.second++;
}
