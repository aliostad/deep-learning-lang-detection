#ifndef NETWORK_QDATASTREAM
#define NETWORK_QDATASTREAM

#include <QDataStream>

#include "camera/camera.h"
#include "hitable/hitable.h"
#include "hitable/sphere.h"
#include "math/rgb.h"
#include "renderer/scene.h"

QDataStream& operator<<(QDataStream& stream, const film::rgb& pixel);
QDataStream& operator>>(QDataStream& stream, film::rgb& pixel);
QDataStream& operator<<(QDataStream& stream, const film::hitable_t& type);
QDataStream& operator>>(QDataStream& stream, film::hitable_t& type);
QDataStream& operator<<(QDataStream& stream, const film::Hitable* hitable);
QDataStream& operator>>(QDataStream& stream, film::Hitable* hitable);
QDataStream& operator<<(QDataStream& stream, const film::Sphere* sphere);
QDataStream& operator>>(QDataStream& stream, film::Sphere* sphere);
QDataStream& operator<<(QDataStream& stream, const film::Scene* scene);
QDataStream& operator>>(QDataStream& stream, film::Scene* scene);
QDataStream& operator<<(QDataStream& stream, const film::Camera* camera);
QDataStream& operator>>(QDataStream& stream, film::Camera* camera);
QDataStream& operator<<(QDataStream& stream, const film::point3& p);
QDataStream& operator>>(QDataStream& stream, film::point3& p);
QDataStream& operator<<(QDataStream& stream, const film::vec3& v);
QDataStream& operator>>(QDataStream& stream, film::vec3& v);

#endif
