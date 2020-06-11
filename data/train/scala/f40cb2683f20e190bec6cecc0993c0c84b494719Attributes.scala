// Copyright 2011-2012 James Michael Callahan
// See LICENSE-2.0 file for licensing information.

package org.scalagfx.houdini.geo.attr

import org.scalagfx.math.{Index2i, Index3i, Vec2d, Vec3d}

import java.io.Writer

//--------------------------------------------------------------------------------------------------
//   T Y P E S  
//--------------------------------------------------------------------------------------------------

object AttrType extends Enumeration {
  val IntType, FloatType, VectorType, StringType = Value
}  
  
trait Attribute
{
  import AttrType._
  
  /** The name of the attribute. */
  val name: String
  
  /** The number of values stored in the attribute. */
  val size: Int
  
  /** The data type of the attribute. */
  val atype: AttrType.Value

  /** Write the attribute definition in GEO file format. */
  def write(out: Writer) {
    val astr = atype match {
      case IntType    => "int"
      case FloatType  => "float"
      case VectorType => "vector"
      case StringType => "index"
    }	
    out.write(name + " " + size + " " + astr + " ")
  }	  
  
  /** Write the place holder value when the attribute is not defined. */
  def writeUndefined(out: Writer)
}

trait IntAttr
  extends Attribute
{
  val size = 1
  val atype = AttrType.IntType
  
  /** The default value. */
  val default: Int
  
  override def write(out: Writer) {
    super.write(out)
    out.write(default + "\n")     	 
  }
  
  def writeUndefined(out: Writer) {
    out.write("0")
  }
}

trait Index2iAttr
  extends Attribute
{
  val size = 2
  val atype = AttrType.IntType
  
  /** The default value. */
  val default: Index2i
  
  override def write(out: Writer) {
    super.write(out)
    out.write(default.x + " " + default.y + "\n")     	 
  }
  
  def writeUndefined(out: Writer) {
    out.write("0 0")
  }
}

trait Index3iAttr
  extends Attribute
{
  val size = 3
  val atype = AttrType.IntType
  
  /** The default value. */
  val default: Index3i
  
  override def write(out: Writer) {
    super.write(out)
    out.write(default.x + " " + default.y + " " + default.z + "\n")     	 
  }
  
  def writeUndefined(out: Writer) {
    out.write("0 0 0")
  }
}

trait FloatAttr
  extends Attribute
{
  val size = 1
  val atype = AttrType.FloatType
  
  /** The default value. */
  val default: Double
  
  override def write(out: Writer) {
    super.write(out)
    out.write(default + "\n")     	 
  }
  
  def writeUndefined(out: Writer) {
    out.write("0")
  }
}

trait Vec2dAttr
  extends Attribute
{
  val size = 2
  val atype = AttrType.FloatType
  
  /** The default value. */
  val default: Vec2d
  
  override def write(out: Writer) {
    super.write(out)
    out.write("%.6f %.6f\n".format(default.x, default.y))     	 
  }
  
  def writeUndefined(out: Writer) {
    out.write("0 0")
  }
}

trait Vec3dAttr
  extends Attribute
{
  val size = 3
  val atype = AttrType.FloatType
  
  /** The default value. */
  val default: Vec3d
  
  override def write(out: Writer) {
    super.write(out)
    out.write("%.6f %.6f %.6f\n".format(default.x, default.y, default.z))     	 
  }
  
  def writeUndefined(out: Writer) {
    out.write("0 0 0")
  }
}

trait StringAttr
  extends Attribute
{
  val size = 1
  val atype = AttrType.StringType
  
  /** The default value. */
  val default: List[String]
  
  override def write(out: Writer) {
    super.write(out)
    out.write(default.size + " " + default.reduce(_ + " " + _) + "\n")
  }
  
  def writeUndefined(out: Writer) {
    out.write("0")
  }
}


//--------------------------------------------------------------------------------------------------
//   K I N D S
//--------------------------------------------------------------------------------------------------

trait PointAttr
  extends Attribute

trait VertexAttr
  extends Attribute

trait PrimitiveAttr
  extends Attribute




