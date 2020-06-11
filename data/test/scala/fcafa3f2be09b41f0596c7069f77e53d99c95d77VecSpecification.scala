package scryetek.vecmath

import org.scalacheck._
import org.scalacheck.Prop._

object VecSpecification extends Properties("Vec") {
  property("--Vec2 is identity") = forAll { (a: Vec2) =>
    -(-a) == a
  }

  property("--Vec3 is identity") = forAll { (a: Vec3) =>
    -(-a) == a
  }

  property("--Vec4 is identity") = forAll { (a: Vec4) =>
    -(-a) == a
  }

  property("Vec2 + Vec2 is commutative") = forAll { (a: Vec2, b: Vec2) =>
    a + b == b + a
  }

  property("Vec2 x-x = Vec2(0,0)") = forAll { (a: Vec2) =>
    a - a ~= Vec2()
  }


  property("Vec3 + Vec3 is commutative") = forAll { (a: Vec3, b: Vec3) =>
    a + b == b + a
  }

  property("Vec3 x-x = Vec3(0,0,0)") = forAll { (a: Vec3) =>
    a - a ~= Vec3()
  }

  property("Vec4 + Vec4 is commutative") = forAll { (a: Vec4, b: Vec4) =>
    a + b == b + a
  }

  property("Vec4 x-x = Vec4(0,0,0,0)") = forAll { (a: Vec4) =>
    a - a ~= Vec4()
  }

  property("Vec2*s/s == Vec2 for s != 0") = forAll(arbitraryVec2.arbitrary, Gen.choose(-100f, 100f) suchThat (math.abs(_) > 0.05f)) { (a: Vec2, s: Float) =>
    a * s / s ~= a
  }

  property("Vec3*s/s == Vec3 for s != 0") = forAll(arbitraryVec3.arbitrary, Gen.choose(-100f, 100f) suchThat (math.abs(_) > 0.05f)) { (a: Vec3, s: Float) =>
    a * s / s ~= a
  }

  property("Vec4*s/s == Vec4 for s != 0") = forAll(arbitraryVec4.arbitrary, Gen.choose(-100f, 100f) suchThat (math.abs(_) > 0.05f)) { (a: Vec4, s: Float) =>
    a * s / s ~= a
  }

  property("Vec2 * Vec2 is commutative") = forAll { (a: Vec2, b: Vec2) =>
    val z = a * b
    (a * b) ~= (b * a)
  }

  property("Vec3 * Vec3 is commutative") = forAll { (a: Vec3, b: Vec3) =>
    val z = a * b
    (a * b) ~= (b * a)
  }

  property("Vec4 * Vec4 is commutative") = forAll { (a: Vec4, b: Vec4) =>
    val z = a * b
    (a * b) ~= (b * a)
  }

  property("Vec2.zNormal works like cross product") = forAll { (a: Vec2, b: Vec2) =>
    a.zNormal(b) ~= (Vec3(a.x, a.y, 0) crossed Vec3(b.x, b.y, 0)).z
  }

  //// Mutable variants.
  // we take care to ensure we didn't trash the original value for each of these.

  property("Vec2.add(v) works like +") = forAll { (a: Vec2, b: Vec2) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec2()
    (a.add(b, aOut) ~= a + b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec2.add(v.x,v.y) works like +") = forAll { (a: Vec2, b: Vec2) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec2()
    (a.add(b.x, b.y, aOut) ~= a + b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec2.sub(v) works like -") = forAll { (a: Vec2, b: Vec2) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec2()
    (a.sub(b, aOut) ~= a - b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec2.sub(v.x,v.y) works like -") = forAll { (a: Vec2, b: Vec2) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec2()
    (a.sub(b.x, b.y, aOut) ~= a - b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec2.scale(s) works like v*s") = forAll(arbitraryVec2.arbitrary, Gen.choose(-10f, 10f) suchThat (math.abs(_) > 0.05)) { (a: Vec2, s: Float) =>
    val aOld = a.copy()
    val aOut = Vec2()
    (a.scale(s, aOut) ~= a * s) && (aOld ~= a)
  }

  property("Vec2.div(s) works like v/s") = forAll(arbitraryVec2.arbitrary, Gen.choose(-10f, 10f) suchThat (math.abs(_) > 0.05)) { (a: Vec2, s: Float) =>
    val aOld = a.copy()
    val aOut = Vec2()
    (a.div(s, aOut) ~= a / s) && (aOld ~= a)
  }

  property("Vec2.negate() works like -v") = forAll { (a: Vec2) =>
    val aOld = a.copy()
    val aOut = Vec2()
    (a.negate(aOut) ~= -a) && (aOld ~= a)
  }

  property("Vec2.normalize() works like v.normalized") = forAll { (a: Vec2) =>
    val aOld = a.copy()
    val aOut = Vec2()
    (a.normalize(aOut) ~= a.normalized) && (aOld ~= a)
  }

  // Vec3

  property("Vec3.add(v) works like +") = forAll { (a: Vec3, b: Vec3) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec3()
    (a.add(b, aOut) ~= a + b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec3.add(v.x,v.y,v.z) works like +") = forAll { (a: Vec3, b: Vec3) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec3()
    (a.add(b.x, b.y, b.z, aOut) ~= a + b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec3.sub(v) works like -") = forAll { (a: Vec3, b: Vec3) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec3()
    (a.sub(b, aOut) ~= a - b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec3.sub(v.x,v.y) works like -") = forAll { (a: Vec3, b: Vec3) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec3()
    (a.sub(b.x, b.y, b.z, aOut) ~= a - b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec3.scale(s) works like v*s") = forAll(arbitraryVec3.arbitrary, Gen.choose(-10f, 10f) suchThat (math.abs(_) > 0.05)) { (a: Vec3, s: Float) =>
    val aOld = a.copy()
    val aOut = Vec3()
    (a.scale(s, aOut) ~= a * s) && (aOld ~= a)
  }

  property("Vec3.div(s) works like v/s") = forAll(arbitraryVec3.arbitrary, Gen.choose(-10f, 10f) suchThat (math.abs(_) > 0.05)) { (a: Vec3, s: Float) =>
    val aOld = a.copy()
    val aOut = Vec3()
    (a.div(s, aOut) ~= a / s) && (aOld ~= a)
  }

  property("Vec3.negate() works like -v") = forAll { (a: Vec3) =>
    val aOld = a.copy()
    val aOut = Vec3()
    (a.negate(aOut) ~= -a) && (aOld ~= a)
  }

  property("Vec3.normalize() works like v.normalized") = forAll { (a: Vec3) =>
    val aOld = a.copy()
    val aOut = Vec3()
    (a.normalize(aOut) ~= a.normalized) && (aOld ~= a)
  }

  property("Vec3.cross works like Vec3.crossed") = forAll { (a: Vec3, b: Vec3) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec3()
    (a.cross(b, aOut) ~= a crossed b) && (bOld ~= b) && (aOld ~= a)
  }

  // Vec4

  property("Vec4.add(v) works like +") = forAll { (a: Vec4, b: Vec4) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec4()
    (a.add(b, aOut) ~= a + b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec4.add(v.x,v.y,v.z,v.w) works like +") = forAll { (a: Vec4, b: Vec4) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec4()
    (a.add(b.x, b.y, b.z, b.w, aOut) ~= a + b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec4.sub(v) works like -") = forAll { (a: Vec4, b: Vec4) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec4()
    (a.sub(b, aOut) ~= a - b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec4.sub(v.x,v.y,v.z,v.w) works like -") = forAll { (a: Vec4, b: Vec4) =>
    val aOld = a.copy()
    val bOld = b.copy()
    val aOut = Vec4()
    (a.sub(b.x, b.y, b.z, b.w, aOut) ~= a - b) && (bOld ~= b) && (aOld ~= a)
  }

  property("Vec4.scale(s) works like v*s") = forAll(arbitraryVec4.arbitrary, Gen.choose(-10f, 10f) suchThat (math.abs(_) > 0.05)) { (a: Vec4, s: Float) =>
    val aOld = a.copy()
    val aOut = Vec4()
    (a.scale(s, aOut) ~= a * s) && (aOld ~= a)
  }

  property("Vec4.div(s) works like v/s") = forAll(arbitraryVec4.arbitrary, Gen.choose(-10f, 10f) suchThat (math.abs(_) > 0.05)) { (a: Vec4, s: Float) =>
    val aOld = a.copy()
    val aOut = Vec4()
    (a.div(s, aOut) ~= a / s) && (aOld ~= a)
  }

  property("Vec4.negate() works like -v") = forAll { (a: Vec4) =>
    val aOld = a.copy()
    val aOut = Vec4()
    (a.negate(aOut) ~= -a) && (aOld ~= a)
  }

  property("Vec4.normalize() works like v.normalized") = forAll { (a: Vec4) =>
    val aOld = a.copy()
    val aOut = Vec4()
    (a.normalize(aOut) ~= a.normalized) && (aOld ~= a)
  }

  property("angleBetween two 3D vectors of magnitude M will rotate A onto B") = forAll { (a: Vec3, b: Vec3) =>
    val q = (a angleBetween b).normalized
    a.normalize()
    b.normalize()
    q * a * 100 approximatelyEqualTo(b * 100, 0.01f)
  }

  property("Vec3.reflected is the same as Vec3.reflect") = forAll { (a: Vec3, b: Vec3) =>
    val aOut = Vec3()
    a.reflect(b.normalized, aOut) ~= a.reflected(b.normalized)
  }

  property("Vec3.reflected is midway between the two vectors") = forAll { (a: Vec3, n: Vec3) =>
    a.normalize().reflect(n.normalize()).scale(10)
    n.normalize()

    (Math.abs((a angleBetween n).toAngleAxis.angle) < Math.PI/2) ==> {
      (a angleBetween n) * (a angleBetween n) * a ~= a.reflected(n)
    }
  }

  property("angleBetween two 2D vectors of magnitude M will rotate A onto B") = forAll { (a: Vec2, b: Vec2) =>
    val angle = a angleBetween b
    a.normalize()
    b.normalize()
    Mat2.rotate(angle) * a * 100 ~= b * 100
  }

  property("Vec2.reflected is the same as Vec2.reflect") = forAll { (a: Vec2, b: Vec2) =>
    val aOut = Vec2()
    a.reflect(b.normalized, aOut) ~= a.reflected(b.normalized)
  }

  property("Vec2.reflected is midway between the two vectors") = forAll { (a: Vec2, n: Vec2) =>
    a.normalize()
    n.normalize()

    (math.abs(a angleBetween n) < Math.PI/2) ==> {
      (a angleBetween n)*2 ~= (a angleBetween a.reflected(n))
    }
  }
}
