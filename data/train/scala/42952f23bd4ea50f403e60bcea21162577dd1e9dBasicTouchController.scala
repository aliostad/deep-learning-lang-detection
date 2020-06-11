package org.sofa.gfx.backend

import org.sofa.math.{Vector3, Point3}
import org.sofa.gfx.Camera
import org.sofa.gfx.surface.{Surface, BasicCameraController}
import org.sofa.gfx.surface.event.MotionEvent

class BasicTouchController(camera:Camera) extends BasicCameraController(camera) {
	val oldPos = Point3(0,0,0)
	val vector = Vector3()
	override def motion(surface:Surface, event:MotionEvent) {
		println("TODO BasicTouchController.motion")
		// if(event.isStart) {
		// 	oldPos.set(event.x, event.y, event.pressure)
		// } else if(event.isEnd) {
		// 	vector.set(event.x-oldPos.x, event.y-oldPos.y, 0)
		// 	oldPos.set(event.x, event.y, event.pressure)
		// 	camera.rotateEyeHorizontal(vector.x*0.005)
		// 	camera.rotateEyeVertical(-vector.y*0.005)
		// } else {
		// 	vector.set(event.x-oldPos.x, event.y-oldPos.y, 0)
		// 	oldPos.set(event.x, event.y, event.pressure)
		// 	camera.rotateEyeHorizontal(vector.x*0.005)
		// 	camera.rotateEyeVertical(-vector.y*0.005)
		// }
	}
}