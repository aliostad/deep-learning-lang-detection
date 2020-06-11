/*
 * Simplex3dEngine - Core Module
 * Copyright (C) 2011, Aleksey Nikiforov
 *
 * This file is part of Simplex3dEngine.
 *
 * Simplex3dEngine is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Simplex3dEngine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package simplex3d.engine
package scene

import scala.collection.mutable.ArrayBuffer
import simplex3d.engine.graphics._


abstract class Scene[G <: GraphicsContext](val name: String) { self =>
  
  // preload some content within a soft bound given by timeSlice, return the overall completion 0-started, 1-done.
  protected def preload(context: RenderContext, frameTimer: FrameTimer, timeSlice: Double) :Double
 
  protected def update(time: TimeStamp) :Unit
  
  protected def render(renderManager: RenderManager, time: TimeStamp) :Unit
  
  // discard unwanted meshes
  protected def manage(context: RenderContext, frameTimer: FrameTimer, timeSlice: Double) :Unit

  protected def cleanup(context: RenderContext) :Unit
  
  
  private[engine] final def ac_preload(context: RenderContext, frameTimer: FrameTimer, timeSlice: Double) =
    preload(context, frameTimer, timeSlice)
 
  private[engine] final def ac_update(time: TimeStamp) =
    update(time)
  
  private[engine] final def ac_render(renderManager: RenderManager, time: TimeStamp) =
    render(renderManager, time)
  
  private[engine] final def ac_manage(context: RenderContext, frameTimer: FrameTimer, timeSlice: Double) =
    manage(context, frameTimer, timeSlice)

  private[engine] final def ac_cleanup(context: RenderContext) =
    cleanup(context)
}
