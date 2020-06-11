
import com.fishuyo.seer._
import dynamic._

object Loader extends SeerScript {
	// val loader = ScriptManager.load("scripts/agentgrid.scala")
	// val loader = ScriptManager.load("scripts/gesture.scala")
	// val loader = ScriptManager.load("scripts/empty.scala")
	// val loader = ScriptManager.load("scripts/texture.scala")
	// val loader = ScriptManager.load("scripts/shader.scala")
	// val loader = ScriptManager.load("scripts/omni.scala")
	// val loader = ScriptManager.load("scripts/puddle.scala")
	// val loader = ScriptManager.load("scripts/field.scala")
	// val loader = ScriptManager.load("scripts/andreou.scala")
	// val loader = ScriptManager.load("scripts/omni_test.scala")
	// val loader = ScriptManager.load("scripts/trees.scala")
	// val loader = ScriptManager.load("scripts/openni.scala")
	// val loader = ScriptManager.load("scripts/cloth.scala")
	// val loader = ScriptManager.load("scripts/wall.scala")
	// val loader = ScriptManager.load("scripts/eisenscript.scala")
	val loader = ScriptLoader("scripts/openni.scala")
	// val loader = ScriptManager.load("scripts/openni_loop.scala")

// 
	override def onUnload(){
		loader.unload
		// loader2.unload
	}
}
Loader