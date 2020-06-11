// -*- C++ -*-
//
// $Id$
#include  "RepoIdSet.h"
#include  "EntryExit.h"

ACE_INLINE
TAO::DCPS::RepoIdSetMap::RepoIdSetMap()
{
  DBG_ENTRY("RepoIdSetMap","RepoIdSetMap");
}


ACE_INLINE TAO::DCPS::RepoIdSet*
TAO::DCPS::RepoIdSetMap::find(RepoId key)
{
  DBG_ENTRY("RepoIdSetMap","find");
  RepoIdSet_rch value;

  if (this->map_.find(key, value) != 0)
    {
      return 0;
    }

  return value._retn();
}


ACE_INLINE ssize_t
TAO::DCPS::RepoIdSetMap::size() const
{
  DBG_ENTRY("RepoIdSetMap","size");
  return this->map_.current_size();
}


ACE_INLINE TAO::DCPS::RepoIdSet*
TAO::DCPS::RepoIdSetMap::find_or_create(RepoId key)
{
  DBG_ENTRY("RepoIdSetMap","find_or_create");
  RepoIdSet_rch value;

  if (this->map_.find(key, value) != 0)
    {
      // It wasn't found.  Create one and insert it.
      value = new RepoIdSet();

      if (this->map_.bind(key, value) != 0)
        {
           ACE_ERROR((LM_ERROR,
                      "(%P|%t) ERROR: Unable to insert new RepoIdSet into "
                      "the RepoIdSetMap.\n"));
           // Return a 'nil' RepoIdSet*
           return 0;
        }
    }

  return value._retn();
}

