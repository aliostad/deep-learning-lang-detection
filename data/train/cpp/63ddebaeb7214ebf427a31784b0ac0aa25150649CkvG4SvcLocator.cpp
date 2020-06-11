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
#include "GaussCherenkov/CkvG4SvcLocator.h"

IDataProviderSvc* CkvG4SvcLocator::RichG4detSvc()
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
        svcLoc->service(CkvG4SvcLocator::a_RichG4DataSvcName , a_detSvc, true );
      if( sc.isFailure() ) 
        { throw GaudiException("CkvG4SvcLocator::Could not locate IDataProviderSvc='" 
                               + CkvG4SvcLocator::a_RichG4DataSvcName + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_detSvc ) 
        { throw GaudiException("CkvG4SvcLocator::IDataProviderSvc*(" 
                               +  CkvG4SvcLocator::a_RichG4DataSvcName + 
                               "') points to NULL!" ,
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      a_detSvc->addRef();
    }
  ///
  return a_detSvc ;
}

IMessageSvc* CkvG4SvcLocator::RichG4MsgSvc ()
{
  static IMessageSvc* a_msgSvc = 0 ;
  //  locate the service 
  if( 0 == a_msgSvc ) 
    {
      ISvcLocator* svcLoc = Gaudi::svcLocator();
      if( 0 == svcLoc ) 
        { throw GaudiException("CkvG4SvcLocator::ISvcLocator* points to NULL!",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      StatusCode sc = 
        svcLoc->service( CkvG4SvcLocator::a_RichG4MessageSvcName , a_msgSvc, true );
      if( sc.isFailure() ) 
        { throw GaudiException("CkvG4SvcLocator::Could not locate IMessageSvc='" 
                               + CkvG4SvcLocator::a_RichG4MessageSvcName  + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_msgSvc ) 
        { throw GaudiException("CkvG4SvcLocator::IMessageSvc*(" 
                               +CkvG4SvcLocator::a_RichG4MessageSvcName + 
                               "') points to NULL!" ,
                               "*DetDescException*" , 
                               StatusCode::FAILURE  ); }
      a_msgSvc->addRef();
    }
  ///
  return a_msgSvc ;
}

IHistogramSvc*   CkvG4SvcLocator::RichG4HistoSvc()
{
  static IHistogramSvc* a_HistoSvc = 0 ;
  //  locate the service 
  if( 0 == a_HistoSvc ) 
    {
      ISvcLocator* svcLoc = Gaudi::svcLocator();
      if( 0 == svcLoc ) 
        { throw GaudiException("CkvG4SvcLocator::ISvcLocator* points to NULL!",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      StatusCode sc = 
        svcLoc->service( CkvG4SvcLocator::a_RichG4HistoSvcName , a_HistoSvc,true  );
      if( sc.isFailure() ) 
        { throw GaudiException("CkvG4SvcLocator::Could not locate IHistogramSvc='" 
                               + CkvG4SvcLocator::a_RichG4HistoSvcName  + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_HistoSvc ) 
        { throw GaudiException("CkvG4SvcLocator::IHistogramSvc*(" 
                               +CkvG4SvcLocator::a_RichG4HistoSvcName + 
                               "') points to NULL!" ,
                               "*DetDescException*" , 
                               StatusCode::FAILURE  ); }
      a_HistoSvc->addRef();
    }
  ///
  return a_HistoSvc ;
}


INTupleSvc*   CkvG4SvcLocator::RichG4NtupleSvc()
{
  static INTupleSvc* a_NtupleSvc = 0 ;
  //  locate the service 
  if( 0 == a_NtupleSvc ) 
    {
      ISvcLocator* svcLoc = Gaudi::svcLocator();
      if( 0 == svcLoc ) 
        { throw GaudiException("CkvG4SvcLocator::ISvcLocator* points to NULL!",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE  ); }
      StatusCode sc = 
        svcLoc->service( CkvG4SvcLocator::a_RichG4NtupSvcName , a_NtupleSvc,true  );
      if( sc.isFailure() ) 
        { throw GaudiException("CkvG4SvcLocator::Could not locate INtupleSvc='" 
                               + CkvG4SvcLocator::a_RichG4NtupSvcName  + "'",
                               "*RichG4Exception*" , 
                               StatusCode::FAILURE); }
      if( 0 == a_NtupleSvc ) 
        { throw GaudiException("CkvG4SvcLocator::INtupleSvc*(" 
                               +CkvG4SvcLocator::a_RichG4NtupSvcName + 
                               "') points to NULL!" ,
                               "*DetDescException*" , 
                               StatusCode::FAILURE  ); }
      a_NtupleSvc->addRef();
    }
  ///
  return a_NtupleSvc ;
}
