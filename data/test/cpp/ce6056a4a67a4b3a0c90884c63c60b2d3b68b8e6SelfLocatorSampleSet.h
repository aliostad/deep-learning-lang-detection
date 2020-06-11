/**
 * @file SelfLocatorSampleSet.h
 *
 * The file contains the definition of the class SelfLocatorSampleSet.
 *
 * @author <a href="mailto:aseek@informatik.uni-bremen.de">Andreas Seekircher</a>
 */

#ifndef __SelfLocatorSampleSet_h_
#define __SelfLocatorSampleSet_h_

#include "Tools/SampleSet.h"

/**
* @class SelfLocatorSampleSet
* A SampleSet with samples from the SelfLocator.
*/
class SelfLocatorSampleSet : public Streamable
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
  SelfLocatorSampleSet() {}

  SampleSetProxy<SelfLocatorSample> sampleSetProxy;

  //sum of weightings in the last sensor update.
  double weightingsSum; 

  //void draw();
};


#endif //__SelfLocatorSampleSet_h_
