#include <string> 
#include <stdio.h>
// GaudiKernel includes 
#include "GaudiKernel/Kernel.h"
#include "GaudiKernel/ISvcLocator.h"
#include "GaudiKernel/IDataProviderSvc.h"
#include "GaudiKernel/IMessageSvc.h"
#include "GaudiKernel/IHistogramSvc.h"
#include "GaudiKernel/Bootstrap.h" 
#include "GaudiKernel/GaudiException.h" 
#include "GaudiKernel/DataObject.h"
#include "GaudiKernel/MsgStream.h"
#include "GaudiKernel/SmartDataPtr.h"
#include "GaudiKernel/IValidity.h"
#include "GaudiKernel/Time.h"
#include "GaudiKernel/IRegistry.h"
#include "GaudiKernel/INTupleSvc.h"

//local
#include "GaussRICH/RichG4SvcLocator.h"

IDataProviderSvc* RichG4SvcLocator::RichG4detSvc()
{ 
  static IDataProviderSvc* a_detSvc = 0 ;

    /// locate te service 
  if( 0 == a_detSvc ) 
    {
      ISvcLocator* svcLoc = Gaudi::svcLocator();
      if( 0 == svcLoc ) 
        { throw GaudiException("RichG4Svclocator::ISvcLocator* points to NULL!",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      StatusCode sc = 
        svcLoc->service(RichG4SvcLocator::a_RichG4DataSvcName , a_detSvc, true );
      if( sc.isFailure() ) 
        { throw GaudiException("RichG4SvcLocator::Could not locate IDataProviderSvc='" 
                               + RichG4SvcLocator::a_RichG4DataSvcName + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_detSvc ) 
        { throw GaudiException("RichG4SvcLocator::IDataProviderSvc*(" 
                               +  RichG4SvcLocator::a_RichG4DataSvcName + 
                               "') points to NULL!" ,
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      a_detSvc->addRef();
    }
  ///
  return a_detSvc ;
}

IMessageSvc* RichG4SvcLocator::RichG4MsgSvc ()
{
  static IMessageSvc* a_msgSvc = 0 ;
  //  locate the service 
  if( 0 == a_msgSvc ) 
    {
      ISvcLocator* svcLoc = Gaudi::svcLocator();
      if( 0 == svcLoc ) 
        { throw GaudiException("RichG4SvcLocator::ISvcLocator* points to NULL!",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      StatusCode sc = 
        svcLoc->service( RichG4SvcLocator::a_RichG4MessageSvcName , a_msgSvc, true );
      if( sc.isFailure() ) 
        { throw GaudiException("RichG4SvcLocator::Could not locate IMessageSvc='" 
                               + RichG4SvcLocator::a_RichG4MessageSvcName  + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_msgSvc ) 
        { throw GaudiException("RichG4SvcLocator::IMessageSvc*(" 
                               +RichG4SvcLocator::a_RichG4MessageSvcName + 
                               "') points to NULL!" ,
                               "*DetDescException*" , 
                               StatusCode::FAILURE  ); }
      a_msgSvc->addRef();
    }
  ///
  return a_msgSvc ;
}

IHistogramSvc*   RichG4SvcLocator::RichG4HistoSvc()
{
  static IHistogramSvc* a_HistoSvc = 0 ;
  //  locate the service 
  if( 0 == a_HistoSvc ) 
    {
      ISvcLocator* svcLoc = Gaudi::svcLocator();
      if( 0 == svcLoc ) 
        { throw GaudiException("RichG4SvcLocator::ISvcLocator* points to NULL!",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      StatusCode sc = 
        svcLoc->service( RichG4SvcLocator::a_RichG4HistoSvcName , a_HistoSvc,true  );
      if( sc.isFailure() ) 
        { throw GaudiException("RichG4SvcLocator::Could not locate IHistogramSvc='" 
                               + RichG4SvcLocator::a_RichG4HistoSvcName  + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_HistoSvc ) 
        { throw GaudiException("RichG4SvcLocator::IHistogramSvc*(" 
                               +RichG4SvcLocator::a_RichG4HistoSvcName + 
                               "') points to NULL!" ,
                               "*DetDescException*" , 
                               StatusCode::FAILURE  ); }
      a_HistoSvc->addRef();
    }
  ///
  return a_HistoSvc ;
}


INTupleSvc*   RichG4SvcLocator::RichG4NtupleSvc()
{
  static INTupleSvc* a_NtupleSvc = 0 ;
  //  locate the service 
  if( 0 == a_NtupleSvc ) 
    {
      ISvcLocator* svcLoc = Gaudi::svcLocator();
      if( 0 == svcLoc ) 
        { throw GaudiException("RichG4SvcLocator::ISvcLocator* points to NULL!",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      StatusCode sc = 
        svcLoc->service( RichG4SvcLocator::a_RichG4NtupSvcName , a_NtupleSvc,true  );
      if( sc.isFailure() ) 
        { throw GaudiException("RichG4SvcLocator::Could not locate INtupleSvc='" 
                               + RichG4SvcLocator::a_RichG4NtupSvcName  + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_NtupleSvc ) 
        { throw GaudiException("RichG4SvcLocator::INtupleSvc*(" 
                               +RichG4SvcLocator::a_RichG4NtupSvcName + 
                               "') points to NULL!" ,
                               "*DetDescException*" , 
                               StatusCode::FAILURE  ); }
      a_NtupleSvc->addRef();
    }
  ///
  return a_NtupleSvc ;
}
