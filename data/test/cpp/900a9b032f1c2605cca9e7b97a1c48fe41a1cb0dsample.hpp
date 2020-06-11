/**
 * sample.hpp - 
 * @author: Jonathan Beard
 * @version: Mon Sep  9 09:01:47 2013
 */
#ifndef _SAMPLE_HPP_
#define _SAMPLE_HPP_  1

typedef double sample_index_t;
typedef double measure_t;


struct Sample{
   Sample()
   {

   }

   Sample( sample_index_t i, measure_t m ) : index( i ),
                                             measure( m )
   {
      /* nothing else to do */
   }

   Sample( const Sample &s )
   {
      index = s.index;
      measure = s.measure;
   }

   sample_index_t index;
   measure_t      measure;
};

#endif /* END _SAMPLE_HPP_ */
