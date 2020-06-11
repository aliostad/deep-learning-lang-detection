

import org.opencv.core.Core
import org.opencv.core.CvType._
import org.opencv.core.Mat
import org.opencv.core.Scalar
import org.opencv.core.Point
import org.opencv.core.Point3

object mat extends App {
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME)
  val M = new Mat(2, 2, CV_8UC3, new Scalar(0, 0, 255));
  println(M.dump)

  M.create(4, 4, CV_8UC(2))
  println(M.dump)

  val E = Mat.eye(4, 4, CV_64F)
  println(s"E = ${E.dump}")

  val O = Mat.ones(2, 2, CV_32F)
  println(s"O = ${O.dump}")

  val Z = Mat.zeros(3, 3, CV_8UC1)
  println(s"Z = ${Z.dump}")

  val RowClone = E.row(1).clone()
  println(s"RowClone = ${RowClone.dump}")

  val R = new Mat(3, 2, CV_8UC3)
  Core.randu(R, 0, 255)
  println(s"R = ${R.dump}")

  val P = new Point(5, 1)
  println(s"Point (2D) =  $P")

  val P3 = new Point3(2, 6, 7)
  println(s"Point (3D) =  $P3")

}