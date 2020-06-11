/*
 * Copyright 2012 Eike Kettner
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

package org.eknet.publet.james.guice

import com.google.inject.{Inject, Singleton}
import com.google.common.eventbus.{EventBus, Subscribe}
import org.eknet.publet.Publet
import org.eknet.publet.vfs.util.{MapContainer, ClasspathContainer}
import org.eknet.publet.vfs.Path
import org.eknet.publet.web.scripts.WebScriptResource
import org.eknet.publet.james.ui._
import org.eknet.publet.web.asset.{AssetCollection, AssetManager}
import org.eknet.publet.web.template.DefaultLayout
import org.eknet.publet.web.asset.Group
import org.eknet.publet.web.guice.PubletStartedEvent
import org.eknet.publet.gitr.partition.GitPartition
import com.google.inject.name.Named
import org.eknet.publet.webeditor.Assets
import org.eknet.publet.web.Config
import org.eknet.publet.vfs.fs.FilesystemPartition

/**
 * @author Eike Kettner eike.kettner@gmail.com
 * @since 01.11.12 12:10
 */
@Singleton
class Setup @Inject() (@Named("james-reports") reportPart: FilesystemPartition, publet: Publet, assetMgr: AssetManager, @Named("james-sieve-scripts") gp: GitPartition) {

  @Subscribe
  def mountResources(event: PubletStartedEvent) {
    val container = new ClasspathContainer(base = "/org/eknet/publet/james/ui/includes")
    publet.mountManager.mount(Path("/publet/james"), container)

    import org.eknet.publet.vfs.ResourceName._
    val scripts = new MapContainer
    scripts.addResource(new WebScriptResource("managedomains.json".rn, new ManageDomains))
    scripts.addResource(new WebScriptResource("manageblacklist.json".rn, new ManageBlacklist))
    scripts.addResource(new WebScriptResource("managemappings.json".rn, new ManageMappings))
    scripts.addResource(new WebScriptResource("manageserver.json".rn, new ManageServer))
    scripts.addResource(new WebScriptResource("managefetchmailaccounts.json".rn, new ManageFetchmailAccounts))
    scripts.addResource(new WebScriptResource("managefetchmailscheduler.json".rn, new ManageFetchmailScheduler))
    scripts.addResource(new WebScriptResource("managemailalias.json".rn, new ManageAlias))
    scripts.addResource(new WebScriptResource("managespool.json".rn, new ManageSpool))
    scripts.addResource(new WebScriptResource("managesieve.json".rn, new ManageSieve))
    scripts.addResource(new WebScriptResource("reportlist.json".rn, new ReportList))
    publet.mountManager.mount(Path("/publet/james/action"), scripts)

    //mount partition for sieve scripts
    publet.mountManager.mount(Path("/publet/james/sieve"), gp)

    //partition for reports
    publet.mountManager.mount(Path("/publet/james/reports"), reportPart)
  }

  @Subscribe
  def setupAssets(event: PubletStartedEvent) {

    assetMgr setup (Groups.jamesGroup, Groups.jamesManager)
    assetMgr setup (Group("default").use(Groups.jamesManager.name))
  }

  object Groups extends AssetCollection {

    override def classPathBase = "/org/eknet/publet/james/ui/includes"

    val jamesGroup = Group("publet.james")
      .add(resource("css/james.css"))
      .add(resource("js/jquery.domain-manager.js"))
      .add(resource("js/jquery.blacklist-manager.js"))
      .add(resource("js/jquery.mapping-manager.js"))
      .add(resource("js/jquery.server-manager.js"))
      .add(resource("js/jquery.fetchmailaccount-manager.js"))
      .add(resource("js/jquery.fetchmailscheduler-manager.js"))
      .add(resource("js/jquery.mailalias-manager.js"))
      .add(resource("js/jquery.spool-manager.js"))
      .add(resource("js/codemirror/sieve.js"))
      .add(resource("js/jquery.sieve-manager.js"))
      .add(resource("js/jquery.reportnav.js"))
      .require(DefaultLayout.Assets.jquery.name, DefaultLayout.Assets.bootstrap.name)
      .require(DefaultLayout.Assets.mustache.name)
      .require(Assets.codemirrorJquery.name)

    val jamesManager = Group("publet.james.manager")
      .forPath("/publet/james/**")
      .require(jamesGroup.name)

  }
}
