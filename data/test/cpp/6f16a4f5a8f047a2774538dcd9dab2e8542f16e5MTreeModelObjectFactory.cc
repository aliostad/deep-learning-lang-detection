//
// File:        MTreeModelObjectFactory.cc
// Package:     MPTCOUPLER kriging coupler
// Copyright:   (c) 2005-2006 The Regents of the University of California
// Revision:    $Revision$
// Modified:    $Date$
// Description: MTree model object factory
//

#include "MTreeModelObjectFactory.h"

#include "kriging/LinearDerivativeRegressionModel.h"
#include "kriging/GaussianDerivativeCorrelationModel.h"
#include "kriging/DerivativeCorrelationModelFactory.h"
#include "kriging/DerivativeRegressionModelFactory.h"
#include "kriging/MultivariateDerivativeKrigingModel.h"

namespace MPTCOUPLER {
  namespace krigcpl {

    //
    // Allocate MultivariateDerivativeKrigingModel
    //

    template<>
    mtreedb::MTreeObjectPtr 
    MTreeModelObjectFactory<krigalg::MultivariateDerivativeKrigingModel>::allocateObject(toolbox::Database& db) const
    {
	
      //
      // instantiate dummy regression and correlation models
      //

      krigalg::DerivativeCorrelationModelPointer correlationModelPtr = 
	krigalg::DerivativeCorrelationModelFactory().build("MPTCOUPLER::krigalg::GaussianDerivativeCorrelationModel");
	
      krigalg::DerivativeRegressionModelPointer regressionModelPtr = 
	krigalg::DerivativeRegressionModelFactory().build("MPTCOUPLER::krigalg::LinearDerivativeRegressionModel"); 
	
      //
      // instantiate new kriging model
      //

      krigalg::MultivariateDerivativeKrigingModel *
	krigingModel = 
	new krigalg::MultivariateDerivativeKrigingModel(regressionModelPtr,
							correlationModelPtr);

      //
      // read the contents of the kriging model from database
      //

      krigingModel->getFromDatabase(db);

      //
      // instantiate MultivariateDerivativeKrigingModelPtr
      //

      krigalg::MultivariateDerivativeKrigingModelPtr krigingModelPtr = 
	krigalg::MultivariateDerivativeKrigingModelPtr(krigingModel);

      //
      // instantiate MTreeKrigingModelObject
      //

      MTreeKrigingModelObject * krigingModelObjectPtr = 
	new MTreeKrigingModelObject(krigingModelPtr);

      //
      // return MTreeObjectPtr
      // 

      return mtreedb::MTreeObjectPtr(krigingModelObjectPtr);
    }

  }
}
