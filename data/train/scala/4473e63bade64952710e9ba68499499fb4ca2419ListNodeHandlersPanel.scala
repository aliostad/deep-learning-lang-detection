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

import org.apache.wicket.markup.html.panel.Panel
import net.cellar.console.CellarConsoleSupport
import net.cellar.console.domain.HandlerData
import net.cellar.core.control.{ManageHandlersResult, ManageHandlersCommand}
import net.cellar.core.Node
import java.util.{Set, List, LinkedList, Arrays}
import org.apache.wicket.markup.html.form.Form
import org.apache.wicket.markup.html.WebMarkupContainer
import org.apache.wicket.markup.html.list.{ListItem, ListView}
import org.apache.wicket.model.{CompoundPropertyModel, Model, IModel, LoadableDetachableModel}
import org.apache.wicket.markup.html.basic.Label
import org.apache.wicket.ajax.AjaxRequestTarget
import org.apache.wicket.ajax.markup.html.form.AjaxFallbackButton

/**
 * @author: iocanel
 */

class ListNodeHandlersPanel(var wicketId: String, var model: IModel[String]) extends Panel(wicketId, model) with CellarConsoleSupport {

  def this(wicketId: String) = this (wicketId, new Model[String]())

  var id = model.getObject
  val form = new Form("form")
  val container = new WebMarkupContainer("container")

  val handlerListView = new ListView[HandlerData]("handlerList", createHandlersModel) {
    def populateItem(item: ListItem[HandlerData]) {
      item.setModel(new CompoundPropertyModel(item.getModel))
      item.add(new Label("name"))
      item.add(new Label("status"))
      item.add(new AjaxFallbackButton("on", form) {
        def onSubmit(target: AjaxRequestTarget, form: Form[_]) {
          var handlersCommand = new ManageHandlersCommand(getClusterManager.generateId)
          handlersCommand.setHandlesName(item.getModelObject.getName)
          handlersCommand.setDestination(getClusterManager.listNodes(Arrays.asList(id)))
          handlersCommand.setStatus(true)
          executeHandlersCommand(handlersCommand, id)
          container.detach
          target.addComponent(container)
        }
      })
      item.add(new AjaxFallbackButton("off", form) {
        def onSubmit(target: AjaxRequestTarget, form: Form[_]) {
          var handlersCommand = new ManageHandlersCommand(getClusterManager.generateId)
          handlersCommand.setHandlesName(item.getModelObject.getName)
          handlersCommand.setDestination(getClusterManager.listNodes(Arrays.asList(id)))
          handlersCommand.setStatus(false)
          executeHandlersCommand(handlersCommand, id)
          container.detach
          target.addComponent(container)
        }
      })
    }
  }

  container.setOutputMarkupId(true)

  form.add(container)
  container.add(handlerListView)
  add(form)

  /**
   * Returns a Loadable detachable model of Handlers
   */
  def createHandlersModel = {
    new LoadableDetachableModel[List[HandlerData]]() {
      def load() = {
        var handlersCommand = new ManageHandlersCommand(getClusterManager.generateId)
        executeHandlersCommand(handlersCommand, id)
      }
    }
  }

  /**
   * Sends a command to a node with the specified nodeId.
   */
  def executeHandlersCommand(handlersCommand: ManageHandlersCommand, nodeIds: String): List[HandlerData] = {
    var handlerDataList: List[HandlerData] = new LinkedList[HandlerData]
    var targetNodes: Set[Node] = getClusterManager.listNodes(Arrays.asList(nodeIds))

    if (targetNodes != null && !targetNodes.isEmpty) {
      var node = targetNodes.toArray(new Array[Node](0))(0)
      handlersCommand.setDestination(targetNodes)
      var map = getExecutionContext.execute[ManageHandlersResult, ManageHandlersCommand](handlersCommand)
      if (map != null && !map.isEmpty) {
        var handerResult = map.get(node)
        handerResult.getHandlers.keySet.toArray(new Array[String](0)).foreach {
          key: String => {
            var handlerData = new HandlerData
            handlerData.setName(key)
            handlerData.setStatus(handerResult.getHandlers.get(key))
            handlerDataList.add(handlerData)
          }
        }
      }
    }
    handlerDataList
  }
}