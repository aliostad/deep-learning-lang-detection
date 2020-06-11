/**<!-------------------------------------------------------------------->
   @file   generators.h
   @author Travis Fischer (fisch0920@gmail.com)
   @date   Fall 2008
   
   @brief
      Convenience header which includes all SampleGenerator implementations
   <!-------------------------------------------------------------------->**/

#ifndef SAMPLE_GENERATORS_H_
#define SAMPLE_GENERATORS_H_

#include <renderers/generators/SampleConsumer.h>

// SampleGenerator implementations
#include <renderers/generators/UniformSampleGenerator.h>
#include <renderers/generators/StochasticSampleGenerator.h>
#include <renderers/generators/JitteredSampleGenerator.h>
#include <renderers/generators/DissolveSampleGenerator.h>
#include <renderers/generators/HilbertSampleGenerator.h>
#include <renderers/generators/SuperSampleGenerator.h>

// Separate SampleGenerator and SampleGeneratorThread interfaces
#include <renderers/generators/SampleGenerator.h>
#include <renderers/generators/SampleGeneratorThread.h>

// Declare both threaded and non-threaded versions of all SampleGenerators
#define FORWARD_DECLARE_SAMPLE_GENERATOR(name)                          \
   typedef name##SG<SampleGenerator>       name##SampleGenerator;       \
   typedef name##SG<SampleGeneratorThread> name##SampleGeneratorThread;

#define DECLARE_SAMPLE_GENERATOR(name)                                  \
   template class name##SG<SampleGenerator>;                            \
   template class name##SG<SampleGeneratorThread>;                      \

namespace milton {
   
   FORWARD_DECLARE_SAMPLE_GENERATOR(Uniform);
   FORWARD_DECLARE_SAMPLE_GENERATOR(Stochastic);
   FORWARD_DECLARE_SAMPLE_GENERATOR(Jittered);
   FORWARD_DECLARE_SAMPLE_GENERATOR(Hilbert);
   
   // Only declare threaded versions of some sample generators
   typedef SuperSG<SampleGeneratorThread>    SuperSampleGeneratorThread;
   typedef DissolveSG<SampleGeneratorThread> DissolveSampleGeneratorThread;
   
}

#endif // SAMPLE_GENERATORS_H_

