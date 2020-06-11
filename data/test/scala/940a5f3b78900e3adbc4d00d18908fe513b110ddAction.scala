/*
 * Copyright 2017 fcomb. <https://fcomb.io>
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

package io.fcomb.models.acl

import cats.syntax.eq._
import io.fcomb.models.common.{Enum, EnumItem}

sealed trait Action extends EnumItem {
  def can(action: Action): Boolean =
    action match {
      case Action.Read   => true
      case Action.Write  => this === Action.Write || this === Action.Manage
      case Action.Manage => this === Action.Manage
    }
}

object Action extends Enum[Action] {
  case object Manage extends Action
  case object Write  extends Action
  case object Read   extends Action

  val values = findValues
}
