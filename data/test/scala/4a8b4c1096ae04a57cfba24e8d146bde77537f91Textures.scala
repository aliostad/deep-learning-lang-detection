package eu.joaocosta.raymarcher

import eu.joaocosta.raymarcher.Objects.DistanceField
import eu.joaocosta.raymarcher.RayMarcher.DistanceSample

object Textures {
  type Texture = (Vec3d => Color)

  def white(v: Vec3d) = Color(255,255,255)
  def colorful(v: Vec3d) = Color(255, (255*(v.y/2 + 0.5)).toInt, (255*(v.z/2 + 0.5)).toInt)
  def striped(v: Vec3d) = {
    val striped = v.z > 0
    Color(if (striped) 100 else 50, 50, 50)
  }

  def paint(c: Color)(obj: DistanceField) = (v: Vec3d) => {
    val old = obj(v)
    DistanceSample(old.dist, old.color.map(_ => c))
  }

}
