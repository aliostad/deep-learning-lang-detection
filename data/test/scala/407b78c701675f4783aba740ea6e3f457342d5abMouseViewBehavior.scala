/**
 * Author: Peter Started:24.05.2011
 */
package client.dataviewer.view3D

import java.util.Enumeration
import javax.media.j3d._
import java.awt.event.{MouseEvent,MouseWheelEvent,InputEvent}
import javax.vecmath.{Vector3d,Point3d}
import scala.collection.JavaConversions._

/**
 * 
 */
class MouseViewBehavior(targetTG:TransformGroup ) extends Behavior {
		 
		val eventArray= Array(MouseEvent.MOUSE_DRAGGED, MouseEvent.MOUSE_PRESSED,MouseEvent.MOUSE_RELEASED,
			MouseEvent.MOUSE_WHEEL)
		val wakeups:Array[WakeupCriterion]=eventArray.map(new WakeupOnAWTEvent(_))
		val wakeupCriterion = new WakeupOr(wakeups)
		val oldTransform=new Transform3D()
		val oldTranslation=new Vector3d		
		val posPoint=new Point3d
		val nullPoint=new Point3d
		val upVector=new Vector3d(0f,0f,1f)
		
		var lastX=0
		var lastY=0
		var horAngle=0d
	  var horRadius=0d							
		var vertAngle=0d
		var vertRadius=0d
		
		var scale=0.01d
		var scrollScale=3d

		def initialize()= { 
			this.wakeupOn(wakeupCriterion);
		}
		
		def getCurrentState()= {
			targetTG.getTransform(oldTransform)
			oldTransform.get(oldTranslation)
			horAngle=Math.atan2(oldTranslation.y,oldTranslation.x)
			horRadius=Math.sqrt(oldTranslation.y*oldTranslation.y+oldTranslation.x*oldTranslation.x)							
			vertAngle=Math.atan2(oldTranslation.z,horRadius)
			vertRadius=Math.sqrt(oldTranslation.z*oldTranslation.z+horRadius*horRadius)
		}
		
		def setTransform() = {
			val newHorRadius=Math.cos(vertAngle)*vertRadius
			posPoint.z=Math.sin(vertAngle)*vertRadius							
			posPoint.x=Math.cos(horAngle)*newHorRadius
			posPoint.y=Math.sin(horAngle)*newHorRadius
			oldTransform.lookAt(posPoint,nullPoint,upVector)
			oldTransform.invert
			targetTG.setTransform(oldTransform)
		}
		
		
		def handleMouseDrag(m:MouseEvent)= {			
			val id = m.getID()			
			if ((id == MouseEvent.MOUSE_DRAGGED) ){
				
				val x=m.getX
				val y=m.getY
				val dx=x-lastX
				val dy=y-lastY				
				getCurrentState
				horAngle-=dx*scale													
				vertAngle=Math.max(Math.min(vertAngle+dy*scale,Math.Pi/2),-Math.Pi/2)							
				setTransform()
				lastX=x
				lastY=y
			} else if(id == MouseEvent.MOUSE_PRESSED) {
				lastX = m.getX();
				lastY = m.getY()
			}		
		}
		
		// called by Java 3D when appropriate stimulus occurs
		def processStimulus(criteria: java.util.Enumeration[_] ):Unit={	
			for(c<-criteria) c match {					
				
				case awt:WakeupOnAWTEvent=>  awt.getAWTEvent().last match { 
					case m:MouseWheelEvent => {
						//println(m.getModifiersEx&InputEvent.BUTTON2_DOWN_MASK)
						if((m.getModifiersEx& InputEvent.BUTTON2_DOWN_MASK)==0) 							
							 {						
								val scroll=m.getWheelRotation
								getCurrentState
								vertRadius+=scrollScale*scroll
								setTransform
							}
					}
					case m:MouseEvent => {						
						//println("EV:"+(m.getModifiersEx&InputEvent.BUTTON2_DOWN_MASK))
						if((m.getModifiersEx& InputEvent.BUTTON2_DOWN_MASK)>0) 							
							handleMouseDrag(m)
					}
					
				}				
			}			
			this.wakeupOn(wakeupCriterion);
		}
	} 
