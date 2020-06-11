/*
 * Copyright 2015 Dennis Vriend
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.github.dnvriend.activiti.event

import com.github.dnvriend.activiti.ActivitiImplicits._
import org.activiti.engine.delegate.event.impl.ActivitiEntityEventImpl
import org.activiti.engine.delegate.event.{ ActivitiEventType, ActivitiEvent, ActivitiEventListener }
import org.activiti.engine.impl.persistence.entity.TaskEntity

class LoggingEventListener extends ActivitiEventListener {

  def dump(event: ActivitiEvent): String = event match {
    case event: ActivitiEntityEventImpl ⇒
      dumpEntity(event.getEntity)
    case _ ⇒ ""
  }

  def dumpEntity(entity: AnyRef): String = entity match {
    case entity: TaskEntity ⇒
      entity.dump
    case _ ⇒ ""
  }

  override def onEvent(event: ActivitiEvent): Unit = event.getType match {
    case ActivitiEventType.TASK_CREATED ⇒
      println(event.dump + "\nentity: " + dump(event))
      event.isInstanceOf[ActivitiEntityEventImpl]
    case ActivitiEventType.TASK_ASSIGNED ⇒
      println(event.dump + "\nentity: " + dump(event))
    case ActivitiEventType.TASK_COMPLETED ⇒
      println(event.dump + "\nentity: " + dump(event))
    case _ ⇒
  }

  override def isFailOnException: Boolean = {
    // The logic in the onEvent method of this listener is not critical, exceptions
    // can be ignored if logging fails...
    false
  }
}
