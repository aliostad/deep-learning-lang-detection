package db

import java.util.concurrent.atomic.AtomicReference

import actors.Contexts._
import models.{Product, User, WithId}

import scala.concurrent.Future
import scala.language.implicitConversions
import scala.reflect.ClassTag
import scala.util.Random


object DbEmulator {
  private val nameToCollection = Map[String, DbEmulatorCollection[_ <: WithId]](
    classOf[Product].getName -> new DbEmulatorCollection[models.Product](DefaultValues.DefaultProducts),
    classOf[User].getName -> new DbEmulatorCollection[User](DefaultValues.DefaultUsers)
  )

  def collection[T <: WithId : ClassTag]: DbEmulatorCollection[T] =
    nameToCollection(scala.reflect.classTag[T].runtimeClass.getName).asInstanceOf[DbEmulatorCollection[T]] //todo: get rid of "asInstanceOf"
}

private[db] class DbEmulatorCollection[T <: WithId](defaultItems: List[T] = Nil) {
  private val InitialDelay = 150
  private val MaxRandomDelay = 100

  implicit private def toRichAtomicReference[V](atomicReference: AtomicReference[V]) = new {

    /**
     * Copy-pasted from [[java.util.concurrent.atomic.AtomicReference]] getAndSet method.
     * This method is hack to increase atomicity.
     * The only way to remove this hack is to get rid of AtomicReference storage.
     * @param newValueFromOld - function: oldValue => newValue
     */
    def compareAndSetFun(newValueFromOld: V => V): V = {
      var oldValueResult: V = null.asInstanceOf[V]
      while (true) {
        val oldValue = atomicReference.get
        if (atomicReference.compareAndSet(oldValue, newValueFromOld(oldValue))) {
          oldValueResult = oldValue
          return oldValue
        }
      }
      oldValueResult
    }
  }

  private val storage = new AtomicReference[List[T]](defaultItems)

  def list: Future[List[T]] = futureResult {
    storage.get
  }

  def insert(entity: T): Future[Option[T]] = futureResult {
    storage.compareAndSetFun(entity :: _)
    Some(entity)
  }

  def update(entity: T): Future[Option[T]] = futureResult {
    storage.compareAndSetFun(entity :: _.filterNot(_.id == entity.id))
    Some(entity)
  }

  def update(entitiesUpdateFun: List[T] => List[T], queryConditionToUpdate: List[T] => Boolean = _ => true): Future[Boolean] = futureResult {
    queryConditionToUpdate(storage.compareAndSetFun(oldValue =>
      if (queryConditionToUpdate(oldValue)) {
        val newValue = entitiesUpdateFun(oldValue)
        newValue ++ oldValue.filterNot(e => newValue.exists(_.id == e.id)) //todo: reduce complexity of N^2
      } else oldValue
    ))
  }

  def delete(entityId: String): Future[Boolean] = futureResult {
    storage.compareAndSetFun(_.filterNot(_.id == entityId))
    true
  }

  def find(entityId: String): Future[Option[T]] = futureResult {
    storage.get().find(_.id == entityId)
  }

  private def futureResult[R](fun: => R) = Future {
    threadSleep()
    fun
  }

  private def threadSleep() {
    Thread.sleep(randomLatency)
  }

  private def randomLatency: Long = {
    InitialDelay + Random.nextInt(MaxRandomDelay)
  }
}

object DefaultValues {
  val DefaultProducts = List(
    Product("Гвозди", 1.5, 130),
    Product("Коты", 777.7, 5),
    Product("Печеньки", 23.3, 23),
    Product("Что-то там еще", 1, 10)
  )
  val DefaultUsers = List(
    User("admin", "admin")
  )
}