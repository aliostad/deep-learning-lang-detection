package com.victorp.chatbot.service.dao

import java.util.concurrent.locks.{ReentrantReadWriteLock, ReadWriteLock}

/**
 * For read/write from/to file with lock
 * 
 * @author victorp
 */
object With {

  val lock:ReadWriteLock = new ReentrantReadWriteLock()
  
  def  readLock[T](body: => T) = {
    val wlock = lock.writeLock()
    wlock.lock()
    try {
      body
    }finally {
      wlock.unlock()
    }  
  }

  def  writeLock[T](body: => T) = {
    val wlock = lock.writeLock()
    wlock.lock()
    try {
      body
    }finally {
      wlock.unlock()
    }
  }

}
