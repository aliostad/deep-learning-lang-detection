// -*- C++ -*-
//
// $Id$
#include   "DCPS/DdsDcps_pch.h"
#include  "RepoIdSet.h"


#if !defined (__ACE_INLINE__)
#include "RepoIdSet.inl"
#endif /* __ACE_INLINE__ */


TAO::DCPS::RepoIdSet::~RepoIdSet()
{
  DBG_ENTRY_LVL("RepoIdSet","~RepoIdSet",5);
}

void
TAO::DCPS::RepoIdSet::serialize(Serializer & serializer)
{
  DBG_ENTRY_LVL("RepoIdSet","serialize",5);
  CORBA::ULong sz = this->size ();
  serializer << sz;
  MapType::ENTRY* entry;

  for (MapType::ITERATOR itr(this->map_);
    itr.next(entry);
    itr.advance())
  {
    serializer << entry->ext_id_;
  }
}


bool
TAO::DCPS::RepoIdSet::equal (RepoIdSet& map)
{
  DBG_ENTRY_LVL("RepoIdSet","equal",5);

  if (this->size () == map.size () && this->size () > 0)
  {
    MapType::ENTRY* entry;

    for (MapType::ITERATOR itr(this->map_);
      itr.next(entry);
      itr.advance())
    {
      MapType::ENTRY* ientry;
      if (map.map_.find (entry->ext_id_, ientry) != 0)
        return false;
    }

    return true;
  }

  return false;
}

