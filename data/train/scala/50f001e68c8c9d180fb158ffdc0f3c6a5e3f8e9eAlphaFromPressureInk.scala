package org.flowpaint.filters
import _root_.org.flowpaint.property.Data
import org.flowpaint.ink.Ink
import org.flowpaint.util.{MathUtils, DataSample, PropertyRegister}

/**
 * 
 * 
 * @author Hans Haggstrom
 */

class AlphaFromPressureInk() extends Ink {

  def processPixel(pixelData: Data) = {

    val pressureEffect = getFloatProperty("pressureEffect", pixelData, 1f)

    val pressure = pixelData.getFloatProperty( PropertyRegister.PRESSURE, 0.5f )
    val oldAlpha = pixelData.getFloatProperty( PropertyRegister.ALPHA, 1 )

    val alpha = MathUtils.interpolate( pressureEffect, oldAlpha, pressure * oldAlpha )

    pixelData.setFloatProperty( PropertyRegister.ALPHA, alpha )
    
  }

}