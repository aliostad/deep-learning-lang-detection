/**
 * \file sample.h
 *
 * \ingroup Empty
 * 
 * \brief Class def header for a class sample
 *
 * @author kazuhiro
 */

/** \addtogroup Empty

    @{*/
#ifndef EXAMPLE_EMPTY_SAMPLE_H
#define EXAMPLE_EMPTY_SAMPLE_H

namespace example {
  /**
     \class sample
     This is a sample class with a greeting function
  */
  class sample{
    
  public:
    
    /// Default constructor
    sample(){}
    
    /// Default destructor
    virtual ~sample(){}

    /// Greet!
    void Greet() const;
  };
}
#endif
/** @} */ // end of doxygen group 

