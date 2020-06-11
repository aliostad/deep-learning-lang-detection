#include "qdatastream.h"

QDataStream& operator<<(QDataStream& stream, const film::rgb& pixel) {
  stream << pixel.r << pixel.g << pixel.b;
  return stream;
}

QDataStream& operator>>(QDataStream& stream, film::rgb& pixel) {
  stream >> pixel.r >> pixel.g >> pixel.b;
  return stream;
}

QDataStream& operator<<(QDataStream& stream, const film::hitable_t& type) {
  stream << static_cast<int>(type);
  return stream;
}

QDataStream& operator>>(QDataStream& stream, film::hitable_t& type) {
  int v;
  stream >> v;
  type = static_cast<film::hitable_t>(v);
  return stream;
}

QDataStream& operator<<(QDataStream& stream, const film::Hitable* hitable) {
  switch (hitable->getType()) {
    case film::hitable_t::SPHERE:
      stream << static_cast<const film::Sphere*>(hitable);
  }
  return stream;
}

QDataStream& operator>>(QDataStream& stream, film::Hitable* hitable) {
  film::hitable_t type;
  stream >> type;

  switch (type) {
    case film::hitable_t::SPHERE:
      stream >> static_cast<film::Sphere*>(hitable);
  }

  return stream;
}

QDataStream& operator<<(QDataStream& stream, const film::Sphere* sphere) {
  stream << film::hitable_t::SPHERE << sphere->center << sphere->radius;
}

QDataStream& operator>>(QDataStream& stream, film::Sphere* sphere) {
  film::point3 center;
  float radius;

  stream >> center >> radius;
  sphere = new film::Sphere(center, radius);

  return stream;
}

QDataStream& operator<<(QDataStream& stream, const film::Scene* scene) {
  stream << scene->getCamera() << scene->getWorld();
  return stream;
}

QDataStream& operator>>(QDataStream& stream, film::Scene* scene) {
  film::Camera* camera;
  film::Hitable* world;
  stream >> camera >> world;
  scene = new film::Scene();
  scene->setCamera(camera);
  scene->setWorld(world);
  return stream;
}

QDataStream& operator<<(QDataStream& stream, const film::Camera* camera) {
  stream << camera->origin << camera->lower_left_corner << camera->horizontal
         << camera->vertical;
  return stream;
}

QDataStream& operator>>(QDataStream& stream, film::Camera* camera) {
  film::point3 origin, lower_left_corner;
  film::vec3 horizontal, vertical;

  stream >> origin >> lower_left_corner >> horizontal >> vertical;

  camera = new film::Camera(origin, lower_left_corner, horizontal, vertical);
  return stream;
}

QDataStream& operator<<(QDataStream& stream, const film::point3& p) {
  stream << p.x << p.y << p.z;
}

QDataStream& operator>>(QDataStream& stream, film::point3& p) {
  stream >> p.x >> p.y >> p.z;
}

QDataStream& operator<<(QDataStream& stream, const film::vec3& v) {
  stream << v.x << v.y << v.z;
}

QDataStream& operator>>(QDataStream& stream, film::vec3& v) {
  stream >> v.x >> v.y >> v.z;
}
