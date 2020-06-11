/*
 * =====================================================================================
 *
 *       Filename:  Sample.cpp
 *
 *    Description:  Class Definition of sample classes
 *
 *        Version:  1.0
 *        Created:  Saturday 24 May 2014 04:31:53  CEST
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Nair Deebul  (deebuls), deebul.nair@smail.inf.h-brs.de
 *   Organization:  
 *
 * =====================================================================================
 */

#include "sample.h"
/*
 *--------------------------------------------------------------------------------------
 *       Class:  Sample
 *      Method:  Sample
 * Description:  constructor
 *--------------------------------------------------------------------------------------
 */
Sample::Sample ()
{
    weight = 0.0;
}  /* -----  end of method Sample::Sample  (constructor)  ----- */

/*
 *--------------------------------------------------------------------------------------
 *       Class:  Sample
 *      Method:  Sample :: Sample
 * Description:  Parametrized constructor
 *--------------------------------------------------------------------------------------
 */
Sample::Sample (cPoint *iPoint, double weight):Point(iPoint)
{
  Point = iPoint;
  weight = iWeight;
}		/* -----  end of method Sample::Sample  ----- */
/*
 *--------------------------------------------------------------------------------------
 *       Class:  Sample
 *      Method:  get_weight
 *--------------------------------------------------------------------------------------
 */
inline double
Sample::get_weight (  ) const
{
  return weight;
}		/* -----  end of method Sample::get_weight  ----- */

/*
 *--------------------------------------------------------------------------------------
 *       Class:  Sample
 *      Method:  set_weight
 *--------------------------------------------------------------------------------------
 */
inline void
Sample::set_weight ( double value )
{
  weight	= value;
  return ;
}		/* -----  end of method Sample::set_weight  ----- */

