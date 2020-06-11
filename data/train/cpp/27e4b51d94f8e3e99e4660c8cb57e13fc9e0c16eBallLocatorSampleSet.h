/**
 * @file BallLocatorSampleSet.h
 *
 * The file contains the definition of the class BallLocatorSampleSet.
 *
 * @author <a href="mailto:aseek@informatik.uni-bremen.de">Andreas Seekircher</a>
 */

#ifndef __BallLocatorSampleSet_h_
#define __BallLocatorSampleSet_h_

#include "Tools/SampleSet.h"

/**
* @class BallLocatorSampleSet
* A SampleSet with samples from the BallLocator.
*/
class BallLocatorSampleSet : public Streamable
{
private:
  virtual void serialize(In* in, Out* out)
  {
    STREAM_REGISTER_BEGIN();
    //STREAM(sampleSetProxy);
    STREAM_REGISTER_FINISH();
  }

public: 
    /** Constructor */
    BallLocatorSampleSet() {}

    SampleSetProxy<BallSample> sampleSetProxy;

};


#endif //__BallLocatorSampleSet_h_
