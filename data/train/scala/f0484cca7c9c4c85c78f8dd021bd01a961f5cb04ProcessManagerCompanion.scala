package com.productfoundry.akka.cqrs.process

import com.productfoundry.akka.cqrs.EntityIdResolution

import scala.reflect.ClassTag

/**
 * Simplifies registration of process managers
 */
abstract class ProcessManagerCompanion[P <: ProcessManager: ClassTag] {

  /**
   * Name of the process manager, based on class name
   */
  val name = implicitly[ClassTag[P]].runtimeClass.getSimpleName

  /**
   * Defines how to resolve ids for this process manager.
   *
   * Events resolving to the same id are sent to the same process manager instance.
   * @return id if the process.
   */
  def idResolution: EntityIdResolution[P]

  implicit val ProcessManagerCompanionObject: ProcessManagerCompanion[P] = this
}
