#include "BoundingSphere.h"

BoundingVolume::BVType BoundingSphere::GetType() const
{
	return BoundingVolume::BV_SPHERE;
}

//Serialization
void BoundingSphere::Serialize(Stream & stream) const
{
	stream.Save(center[0]);
	stream.Save(center[1]);
	stream.Save(center[2]);
	stream.Save(radius);
}
void BoundingSphere::Unserialize(Stream & stream)
{
	stream.Load(center[0]);
	stream.Load(center[1]);
	stream.Load(center[2]);
	stream.Load(radius);
}
void BoundingSphere::SerializeTypeId(Stream & stream) const
{
	stream.Save("BoundingSphere");
}