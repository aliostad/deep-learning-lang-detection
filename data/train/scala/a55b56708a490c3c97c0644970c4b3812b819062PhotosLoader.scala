package com.test.actors

import scala.actors.Actor
import android.util.Log
import android.graphics.Bitmap
import CacheActor._
import DownloadActor._

object PhotosLoader extends Actor {
  start()

  case class LoadImage(photoToLoad: String)
  case class ImageLoaded(photoToLoad:String, bitmap: Bitmap)

  override def act() {
    loop {
      react {
        case LoadImage(photoToLoad) => {
          Log.d("com.test.actors", "LoadImage with photoToLoad " + photoToLoad + " from " + Thread.currentThread)
          Log.d("com.test.actors", "sender1 " + sender);
          val bitmapFromCache : Option[Bitmap] = (CacheActor !? Contains(photoToLoad)).asInstanceOf[Option[Bitmap]]
          Log.d("com.test.actors", "sender2 " + sender);
          val bitmap : Bitmap = bitmapFromCache getOrElse {
            (DownloadActor !? DownloadBitmap(photoToLoad)).asInstanceOf[Bitmap]
          }

          Log.d("com.test.actors", "sender3 " + sender);
          if ( bitmap != null ) {
            CacheActor ! Put(photoToLoad, bitmap)
          }
          Log.d("com.test.actors", "sender4 " + sender);
          sender ! ImageLoaded(photoToLoad, bitmap)

        }
      }
    }
  }
}
