package com.iobeam.spark.streams.testutils

import com.iobeam.spark.streams.transforms.{FieldTransform, FieldTransformState}

/**
  * Returns previous value in series. Used to test correct ordering.
  */
class TestFilterState extends FieldTransformState {

    var oldSample = 0.0

    override def sampleUpdateAndTest(timeUs: Long,
                                     batchTimeUs: Long,
                                     reading: Any): Option[Any] = {
        val retVal = oldSample
        oldSample = reading.asInstanceOf[Double]
        Some(retVal)
    }
}

class TestFilter extends FieldTransform {
    override def getNewTransform: FieldTransformState = new TestFilterState
}