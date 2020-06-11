/*
 * Copyright 2014 porter <https://github.com/eikek/porter>
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

package porter.app.openid.routes.manage

import porter.client.messages._
import porter.app.openid.routes.OpenIdActors

trait ClearRememberedRealms {
  self: ManageRoutes with OpenIdActors =>

  def clearReamls: Submission = {
    case Action("clearRememberedRealms", ctx, acc) =>
      val propname = rememberRealmPropName
      val nacc = acc.updatedProps(_.filterKeys(k => !k.startsWith(propname)))
      ctx.porterRef ! UpdateAccount(settings.defaultRealm, nacc)
      renderUserPage(nacc, Message.success("Decision cache cleared."))
  }
}
