package com.alex.cga.animation

import swing.Graphics2D
import java.awt.geom.{Ellipse2D, Line2D}

import com.alex.cga.{Container, algorithm}
import Container.{innerPolygon, outerPolygon, pts, drs}
import algorithm.PlainFigureRelation._
import algorithm.SimpleRelationResolvers._
import algorithm.{binaryTest, octaneTest}
import com.alex.cga.geometry.Direction
import com.alex.cga.geometry.plain._
import Point._
import com.alex.cga.sugar.Extensions.{draw => drawFigure}

import scala.annotation.tailrec

class Sheeps { self: Animatable with MakeAnimation with DrawGraphics2DAnimation =>
  import Sheeps.SheepsInFence

  val numOfPoints = 10
  val delay = 4

  type DynamicState = SheepsInFence

  val initialState = (innerPolygon, (pts(numOfPoints), drs(numOfPoints)), outerPolygon)

  def draw(ds: DynamicState)(implicit g: Graphics2D) = {
    val (ip, (pts, _), op) = ds

    drawFigure(ip)
    drawFigure(pts)
    drawFigure(op)
  }

  def findNewState(ind: Int) = {
    val (ip, (pts, drs), op) = animation(ind)
    val (npts, ndrs) = findNext(drs, pts)
    (ip, (npts, ndrs), op)
  }

  def findNext(directions: List[Direction], points: List[Point]) = {
    @tailrec
    def loop
    (pts: List[Point], drs: List[Direction], npts: List[Point], ndrs: List[Direction]):
    (List[Point], List[Direction]) = {
      if (pts.isEmpty) (npts, ndrs)
      else {
        val oldP :: oldPts = pts
        val oldD :: oldDrs = drs
        val newP = oldP + oldD
        val pVector = Segment(oldP, newP)
        val rel = (newP R innerPolygon, newP R outerPolygon)

        rel match {
          case (Out, In) => loop(oldPts, oldDrs, newP :: npts, oldD :: ndrs)
          case (In, _) => loop(oldPts, oldDrs, npts, ndrs)
          case (_, Out) =>
            val intersectedSegment = (pVector intersect outerPolygon).orNull
            val newD = pVector hit intersectedSegment
            loop(oldPts, oldDrs, oldP - oldD * 2 :: npts, newD :: ndrs)
        }
      }
    }
    loop(points, directions, List(), List())
  }
}

object Sheeps {
  type SheepsInFence = (ConcavePolygon, (List[Point], List[Direction]), ConvexPolygon)
}
