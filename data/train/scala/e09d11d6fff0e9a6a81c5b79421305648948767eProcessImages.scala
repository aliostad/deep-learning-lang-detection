package com.github.joe.adams.steps.readimages


import akka.stream.scaladsl.{Sink, Source}
import com.github.joe.adams.service.{AkkaService, AkkaServiceImpl}

import scala.concurrent.Future

object ProcessImages {
  def apply(names: Seq[String]): Future[Option[Int]] = ProcessImagesImpl(names)
}

private[readimages] trait ProcessImages extends (Seq[String] => Future[Option[Int]]) {

  def processImages(names: Seq[String]): Future[Option[Int]]

  def processImage(imageName: String): Future[Option[Int]]
}


private[readimages] trait ProcessImagesWithMethods extends ProcessImages {
  this: AkkaService =>

  override def apply(names: Seq[String]): Future[Option[Int]] = processImages(names)

  override def processImages(names: Seq[String]): Future[Option[Int]] = Source.fromIterator(() => names.toIterator).mapAsync(100)(processImage).runWith(Sink.last)

  override def processImage(imageName: String): Future[Option[Int]] = ProcessImage(imageName)

}

private[readimages] object ProcessImagesImpl extends ProcessImagesWithMethods with AkkaServiceImpl

