#include "ReducedModel.h"


typedef ReducedVarianceModelBuilder<vtkPolyData> ModelBuilderType;

SEXP ReducedModel(SEXP pPCA_,SEXP npc_,SEXP exVar_) {
  try {
    unsigned int npc = as<unsigned int>(npc_);
    double exVar = as<double>(exVar_);
    shared_ptr<vtkMeshModel> model = pPCA2statismo(pPCA_);
    //shared_ptr<vtkMeshModel> reducedModel;
    shared_ptr<ModelBuilderType> modelBuilder(ModelBuilderType::Create());
    if (npc > 0) {
      shared_ptr<vtkMeshModel> reducedModel(modelBuilder->BuildNewModelWithLeadingComponents(model.get(), npc));
      return statismo2pPCA(reducedModel);
    
      
    } else {
      shared_ptr<vtkMeshModel> reducedModel(modelBuilder->BuildNewModelWithVariance(model.get(), exVar));
      return statismo2pPCA(reducedModel);

    }
  
  } catch (StatisticalModelException& e) {
    ::Rf_error("Exception occured while building the shape model\n");
    ::Rf_error("%s\n",  e.what());
    
  } catch (std::exception& e) {
    ::Rf_error( e.what());
  } catch (...) {
    ::Rf_error("unknown exception");
  }
  
}
