#include "ModelCoefficients.h"

ModelCoefficients::ModelCoefficients (UInt32 n)
  :m_coefficients (n, 0)
{
}

ModelCoefficients::~ModelCoefficients ()
{
}

const Float32&
ModelCoefficients::operator[] (UInt32 n) const
{
  return m_coefficients[n];
}

Float32&
ModelCoefficients::operator[] (UInt32 n)
{
  return m_coefficients[n];
}

ModelCoefficients::iterator
ModelCoefficients::begin ()
{
  return m_coefficients.begin ();
}

ModelCoefficients::const_iterator
ModelCoefficients::begin () const
{
  return m_coefficients.begin ();
}

ModelCoefficients::iterator
ModelCoefficients::end ()
{
  return m_coefficients.end ();
}

ModelCoefficients::const_iterator
ModelCoefficients::end () const
{
  return m_coefficients.end ();
}

ModelCoefficients::reverse_iterator
ModelCoefficients::rbegin ()
{
  return m_coefficients.rbegin ();
}

ModelCoefficients::const_reverse_iterator
ModelCoefficients::rbegin () const
{
  return m_coefficients.rbegin ();
}

ModelCoefficients::reverse_iterator
ModelCoefficients::rend ()
{
  return m_coefficients.rend ();
}

ModelCoefficients::const_reverse_iterator
ModelCoefficients::rend () const
{
  return m_coefficients.rend ();
}

UInt32
ModelCoefficients::getSize () const
{
  return m_coefficients.size ();
}