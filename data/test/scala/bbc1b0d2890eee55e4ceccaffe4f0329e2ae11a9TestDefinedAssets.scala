package com.razie.pub.assets.samples

import com.razie.pub.agent._
import com.razie.pub.agent.test._
import com.razie.agent._
import com.razie.assets._
import com.razie.pub.base.data._
import com.razie.pub.base._
import com.razie.pub.base.log._
import com.razie.pub.comms._
import com.razie.pub.assets._
import razie.actionables._
import razie.actionables.library._
import org.scalatest.junit._
import razie.assets._
import razie.base._


/** test asset definition samples, complete with bindings */
class TestDefinedAssets extends JUnit3Suite {

   var agent:razie.SimpleAgent = null

   override def setUp = {
      NoStatics.reset
      LightAuthBase.init(new LightAuthBase("mutant"))

      agent = razie.SimpleAgent.local("4446").onInit.onStartup 
      agent inContext {
         AssetMgr.init (new InventoryAssetMgr)
      } 
   }

   def test1 = expect (true) {
      val ak = new SampleAsset1
      agent inContext razie.Assets.manage(ak)

      val action = new AssetActionToInvoke(Agents.me.url, ak.getKey(), razie.AI("testing"));

      val result:String = (action act null).asInstanceOf[String]
      (result contains "SampleAsset1")  && (result contains "testing")
   }

   def test2 = expect (true) {
      val ak = new SampleAsset2
      agent inContext razie.Assets.manage(ak)

      val action = new AssetActionToInvoke(agent.handle.url, ak.getKey(), razie.AI("details"));

      val result:String = (action act null).asInstanceOf[String]
      (result contains "SampleAsset2")  && (result contains "testing")
   }

   def testBlankAsset = expect (true) {
      val ak1 = new BlankAsset ("blankie1", "first", razie.AA("kuku", "kiki1"))
      val ak2 = new BlankAsset ("blankie1", "second", razie.AA("kuku", "kiki2"))
      agent inContext {
         razie.Assets.manage(ak1)
         razie.Assets.manage(ak2)
      }

      val action = new AssetActionToInvoke(agent.handle.url, ak1.getKey(), razie.AI("sayhi"));
      val result:String = (action act null).asInstanceOf[String]
      
      val action2 = new AssetActionToInvoke(agent.handle.url, ak2.getKey(), razie.AI("say"), new AttrAccessImpl("what", "kuku"));
      val result2:String = (action2 act null).asInstanceOf[String]
      (result contains "hi")  && (result2 contains "kiki2")
   }

   override def tearDown = {
      agent.onShutdown.join
      super.tearDown
   }
}
