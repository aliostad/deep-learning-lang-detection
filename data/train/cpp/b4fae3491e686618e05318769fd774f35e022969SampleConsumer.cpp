/**<!-------------------------------------------------------------------->
   @file   SampleConsumer.cpp
   @author Travis Fischer (fisch0920@gmail.com)
   @date   Fall 2008
   
   @brief
      Threaded point sample evaluation (represents the 'consumer' in the 
   classic producer/consumer problem)
   
   @see SampleGenerator
   <!-------------------------------------------------------------------->**/

#include "SampleConsumer.h"
#include <PointSampleRenderer.h>
#include <RenderOutput.h>
#include <PointSample.h>
#include <QtCore/QtCore>

namespace milton {

void SampleConsumer::init() {
   ASSERT(m_renderer);
}

void SampleConsumer::run() {
   ASSERT(m_renderer);
   
   //setPriority(NormalPriority);
   //cerr << priority() << endl;
   
   RenderOutput *output = m_renderer->getOutput();
   PointSample pointSample;
   
   while(m_renderer->getSharedSample(pointSample)) {
      m_renderer->sample(pointSample);
      
      output->addSample(pointSample);
   }
}

}

