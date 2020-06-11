package com.test.actors

import scala.actors.Actor
import android.graphics.Bitmap
import android.util.Log
import scala.collection.mutable.HashMap

object CacheActor extends Actor {
  case class Contains(photoToLoad: String)
  case class Put(photoToLoad: String, bitmap: Bitmap)

  val cacheMap = new HashMap[String, Bitmap]
  start()

  def act(){
    loop {
      react {
        case Contains(photoToLoad) => {
          Log.d("com.test.actors", "Contains with " + photoToLoad + " from " + Thread.currentThread);
          reply(cacheMap.get(photoToLoad))
        }
        case Put(photoToLoad, bitmap) => {
          Log.d("com.test.actors", "Put with " + photoToLoad + " from " + Thread.currentThread);
          cacheMap += photoToLoad -> bitmap
        }
      }
    }
    
  }

}