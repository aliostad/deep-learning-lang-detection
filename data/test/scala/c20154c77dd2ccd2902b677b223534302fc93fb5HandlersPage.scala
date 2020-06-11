/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package net.cellar.console.pages


import org.apache.wicket.behavior.AttributeAppender
import org.apache.wicket.model.{LoadableDetachableModel, Model}
import net.cellar.core.control.{ManageHandlersResult, ManageHandlersCommand}
import java.util.{LinkedList, List}

/**
 * @author iocanel
 */

class HandlersPage extends BasePage {
  handlersPageLink.add(new AttributeAppender("class", new Model[String]("current"), ""))

  /**
   * Returns a Loadable detachable model of Handlers
   */
  def createHandlersModel = {
    new LoadableDetachableModel[List[ManageHandlersResult]]() {
      def load() = {
        val clusterManager = getClusterManager
        val executionContext = getExecutionContext
        var handlersCommand = new ManageHandlersCommand(clusterManager.generateId)
        var map = executionContext.execute[ManageHandlersResult, ManageHandlersCommand](handlersCommand)
        new LinkedList(map.values)
      }
    }
  }
}

