/**
 * \file sample.h
 *
 * \ingroup FlashHypothesis
 * 
 * \brief Class def header for a class sample
 *
 * @author wketchum
 */

/** \addtogroup FlashHypothesis

    @{*/
#ifndef LARLITE_FLASHHYPOTHESIS_SAMPLE_H
#define LARLITE_FLASHHYPOTHESIS_SAMPLE_H

#include <iostream>

/**
   \class sample
   User defined class FlashHypothesis ... these comments are used to generate
   doxygen documentation!
 */
class sample{

public:

  /// Default constructor
  sample(){ std::cout << "sample created!" << std::endl; }

  /// Default destructor
  virtual ~sample(){};

};

#endif
/** @} */ // end of doxygen group 

