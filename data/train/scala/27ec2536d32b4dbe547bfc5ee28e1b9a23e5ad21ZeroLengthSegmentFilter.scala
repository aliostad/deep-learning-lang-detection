package org.flowpaint.filters

import org.flowpaint.property.{DataImpl, Data}
import org.flowpaint.util.{MathUtils, DataSample, PropertyRegister}

/**
 *  Removes segments with zero length, and merges their properties with subsequent points
 *
 * @author Hans Haggstrom
 */
class ZeroLengthSegmentFilter extends PathProcessor {
    private var previousData = new DataImpl()
    private var temp = new DataImpl()

    private var oldX = 0f
    private var oldY = 0f
    private var oldX2 = 0f
    private var oldY2 = 0f

    override protected def onInit() = {

        previousData.clear
        temp.clear

        oldX = 0f
        oldY = 0f
        oldX2 = 0f
        oldY2 = 0f
    }


    protected def processPathPoint(pointData: Data) : List[Data] =  {
        var result : List[Data] = Nil

        val smoothing = getFloatProperty("smoothing", pointData, 0.2f)
        val FILTER_DISTANCE = getFloatProperty("filterDistance", pointData, 1.5f)

        val smooth = if (firstPoint) 0f else smoothing

        val newX = MathUtils.interpolate(smooth, pointData.getFloatProperty(PropertyRegister.PATH_X, oldX2), oldX2)
        val newY = MathUtils.interpolate(smooth, pointData.getFloatProperty(PropertyRegister.PATH_Y, oldY2), oldY2)
        /*
            val newX = pointData.getProperty("x",0)
            val newY = pointData.getProperty("y",0)
        */

        pointData.setFloatProperty(PropertyRegister.PATH_X, newX)
        pointData.setFloatProperty(PropertyRegister.PATH_Y, newY)

        oldX2 = newX
        oldY2 = newY

        if (MathUtils.squaredDistance(oldX, oldY, newX, newY) <= FILTER_DISTANCE * FILTER_DISTANCE)
            {
                previousData.setValuesFrom(pointData)

                // Discard (do not process) the point
            }
        else {

            oldX = newX
            oldY = newY

            // Overwrite values with latest ones
            previousData.setValuesFrom(pointData)

            /*
                  temp.clear
                  temp.setValuesFrom(pointData)
            */

            // Copy all values to the newest point, to also catch any old ones that were set for discarded points
            // and not reset with the latest point data.
            pointData.setValuesFrom(previousData)

            /*
                  // Clear the old temp data, but retain the most recent
            //      previousData.clear
                  previousData.setValuesFrom( temp )
            */

            // Process normally
            result = List(pointData)
        }

      return result
    }


}