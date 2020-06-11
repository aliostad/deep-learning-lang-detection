
#ifndef __TIME_SERVANT_LOCATOR_H
#define __TIME_SERVANT_LOCATOR_H

#ident "$Id$"

#include "tao/PortableServer/PortableServer.h"

class TimeServantLocator : 
public virtual PortableServer::ServantLocator
{
 public:
  TimeServantLocator (void);
  virtual ~TimeServantLocator (void);

  virtual PortableServer::Servant preinvoke 
    (const PortableServer::ObjectId & oid, 
     PortableServer::POA_ptr poa,
     const char *operation,
     void * &cookie)
    throw (CORBA::SystemException , PortableServer::ForwardRequest);

  virtual void  postinvoke (const PortableServer::ObjectId & oid, 
                            PortableServer::POA_ptr poa,
                            const char *operation,
                            void *cookie,
                            PortableServer::Servant servant)
    throw (CORBA::SystemException);

 private:

  // copy not supported
  TimeServantLocator (const TimeServantLocator & t);
  void operator = (const TimeServantLocator & t);
};

#endif // __TIME_SERVANT_LOCATOR_H
