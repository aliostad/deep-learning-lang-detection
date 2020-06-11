package com.biosimilarity.emeris

import com.google.inject.util.Modules
import com.google.inject.{Provider, Module, AbstractModule}
import m3.servlet.M3ServletModule
import net.model3.guice.M3GuiceModule
import com.biosimilarity.emeris.servletbeans.DumpDataSet
import com.biosimilarity.emeris.servletbeans.DumpMultiAgentDataSet
import com.biosimilarity.emeris.servletbeans.LoadDataSet
import com.biosimilarity.emeris.servletbeans.LoadMultiAgentDataSet
import com.biosimilarity.emeris.servletbeans.ImageData
import com.biosimilarity.emeris.servletbeans.AgentInfo
import com.biosimilarity.emeris.servletbeans.CreateAgent
import com.biosimilarity.emeris.servletbeans.DeleteAgent
import net.model3.guice.bootstrap.ApplicationName

class GuiceModule extends AbstractModule with Provider[Module] {

  def get = Modules.`override`(new M3GuiceModule()).`with`(new MyServletModule, this);

  def configure = {
    bind(classOf[ApplicationName]).toInstance(new ApplicationName("biosim"))
  }
 

  class MyServletModule extends M3ServletModule {

    override def configureServlets = {
      
      serve("/ws") `with` new SocketServlet
      
      serveBean[AgentInfo]("/api/agentInfo")
      serveBean[CreateAgent]("/api/insertAgent")
      serveBean[DeleteAgent]("/api/deleteAgent")
      
      serveBean[ImageData]("/blobs/")
      serveBean[DumpDataSet]("/api/dumpDataSet")
      serveBean[DumpMultiAgentDataSet]("/api/dumpMultiAgentDataSet")
      serveBean[LoadDataSet]("/api/loadDataSet")
      serveBean[LoadMultiAgentDataSet]("/api/loadMultiAgentDataSet")
      
      addServletBeanFilter
      
    }
    
  }
  
}

