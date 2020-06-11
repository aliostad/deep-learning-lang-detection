//
//  StringUtilities.cpp
//  BezierDisplay
//
//  Created by Papoj Thamjaroenporn on 11/9/12.
//  Copyright (c) 2012 Papoj Thamjaroenporn. All rights reserved.
//

#include "StringUtilities.h"

namespace outputmod
{

std::ostream& startred( std::ostream& stream )
{
  stream << "\033[31;1m";
  return stream;
}

std::ostream& endred( std::ostream& stream )
{
  stream << "\033[m";
  return stream;
}

std::ostream& startgreen( std::ostream& stream )
{
  stream << "\033[32;1m";
  return stream;
}

std::ostream& endgreen( std::ostream& stream )
{
  stream << "\033[m";
  return stream;
}

std::ostream& startpink( std::ostream& stream )
{
  stream << "\033[35;1m";
  return stream;
}

std::ostream& endpink( std::ostream& stream )
{
  stream << "\033[m";
  return stream;
}

std::ostream& startblue( std::ostream& stream )
{
  stream << "\033[34;1m";
  return stream;
}

std::ostream& endblue( std::ostream& stream )
{
  stream << "\033[m";
  return stream;
}

}
