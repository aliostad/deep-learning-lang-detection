// $Id$

namespace T3
{
//
// Auto_Model_Impl
//
inline
Auto_Model_Impl::Auto_Model_Impl (void)
: ref_count_ (1)
{

}

//
// Auto_Model_Impl
//
inline
Auto_Model_Impl::Auto_Model_Impl (const GAME::Mga::Object_in obj)
: ref_count_ (1)
{
  this->store (obj);
}

//
// ~Auto_Model_Impl
//
inline
Auto_Model_Impl::~Auto_Model_Impl (void)
{
  this->cleanup ();
}

//
// model
//
inline
GAME::Mga::Object Auto_Model_Impl::model (void)
{
  return this->model_;
}

//
// model
//
inline
const GAME::Mga::Object Auto_Model_Impl::model (void) const
{
  return this->model_;
}

//
// inc_refcount
//
inline
void Auto_Model_Impl::inc_refcount (void)
{
  ++ this->ref_count_;
}

//
// refcount
//
inline
size_t Auto_Model_Impl::refcount (void) const
{
  return this->ref_count_;
}

}
