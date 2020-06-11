/** 
 * \file MDCG/include/MDCG/model-builder.hpp
 *
 * \author Tristan Vanderbruggen
 *
 */

#ifndef __MDCG_TOOLS_MODEL_BUILDER_HPP__
#define __MDCG_TOOLS_MODEL_BUILDER_HPP__

#include "MDCG/Model/model.hpp"

#include <map>
#include <vector>
#include <iostream>

namespace MFB {
  template <template <typename T> class Model> class Driver;

  template <typename Object> class Sage;

  struct api_t;
};

namespace MDCG {

namespace Tools {

class ModelBuilder {
  public:
    typedef size_t model_id_t;

  private:
    MFB::Driver<MFB::Sage> & p_driver;
    std::vector<Model::model_t> p_models;

  private:
    
    template <Model::model_elements_e kind>
    void toDotNode(std::ostream & out, Model::element_t<kind> * element) const;

    template <Model::model_elements_e kind>
    void setParentFromScope(Model::model_t & model, Model::element_t<kind> * element, SgSymbol * symbol);
  
    void add(Model::model_t & model, const MFB::api_t * api);
    void add(Model::model_t & model, SgNamespaceSymbol * namespace_symbol);
    void add(Model::model_t & model, SgVariableSymbol * variable_symbol);
    void add(Model::model_t & model, SgFunctionSymbol * function_symbol);
    void add(Model::model_t & model, SgClassSymbol * class_symbol);
    void add(Model::model_t & model, SgMemberFunctionSymbol * member_function_symbol);

    void add(Model::model_t & model, SgType * type);

  public:
    ModelBuilder(MFB::Driver<MFB::Sage> & driver);

    MFB::Driver<MFB::Sage> & getDriver();
    const MFB::Driver<MFB::Sage> & getDriver() const;

    size_t create();

    void add(
      size_t model_id_t,
      const std::string & name,
      const std::string & path,
      std::string suffix
    );

    const Model::model_t & get(model_id_t model) const;

    void print(std::ostream & out, model_id_t model) const;
};

}

}

#endif /* __MDCG_TOOLS_MODEL_BUILDER_HPP__ */

