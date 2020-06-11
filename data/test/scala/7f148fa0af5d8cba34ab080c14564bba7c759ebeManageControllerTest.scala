package com.wisedu.next.admin.controllers

import javax.inject.Inject

import com.twitter.finatra.http.test.EmbeddedHttpServer
import com.twitter.finatra.json.FinatraObjectMapper
import com.twitter.inject.server.FeatureTest
import com.wisedu.next.admin.NextServer

/**
  * AuthControllerTest
  *
  * @author croyson
  *         contact 14116004@wisedu.com
  *         date 16/5/10
  */
class ManageControllerTest extends FeatureTest{
   override val server = new EmbeddedHttpServer(new NextServer,Map("dsc.hosts"->"172.16.31.201","local.doc.root"->"/Users/croyson/orangeWorkSpace/Next-Admin/src/asserts/"))
   @Inject var objectMapper: FinatraObjectMapper =_

   "Server" should {

   }
 }
