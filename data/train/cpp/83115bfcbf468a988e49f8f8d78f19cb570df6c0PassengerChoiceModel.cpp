// //////////////////////////////////////////////////////////////////////
// Import section
// //////////////////////////////////////////////////////////////////////
// STL
#include <cassert>
#include <sstream>
// StdAir
#include <stdair/stdair_exceptions.hpp>
#include <stdair/basic/PassengerChoiceModel.hpp>

namespace stdair {
  
  // //////////////////////////////////////////////////////////////////////
  const std::string PassengerChoiceModel::_labels[LAST_VALUE] =
    { "HardRestrictionModel", "PriceOrientedModel", "HybridModel"};

  // //////////////////////////////////////////////////////////////////////
  const char PassengerChoiceModel::
  _modelLabels[LAST_VALUE] = { 'R', 'P', 'H'};

  
  // //////////////////////////////////////////////////////////////////////
  PassengerChoiceModel::PassengerChoiceModel()
    : _model (LAST_VALUE) {
    assert (false);
  }

  // //////////////////////////////////////////////////////////////////////
  PassengerChoiceModel::
  PassengerChoiceModel (const PassengerChoiceModel& iPassengerChoiceModel)
    : _model (iPassengerChoiceModel._model) {
  }

  // //////////////////////////////////////////////////////////////////////
  PassengerChoiceModel::
  PassengerChoiceModel (const EN_PassengerChoiceModel& iPassengerChoiceModel)
    : _model (iPassengerChoiceModel) {
  }

  // //////////////////////////////////////////////////////////////////////
  PassengerChoiceModel::PassengerChoiceModel (const char iModel) {
    switch (iModel) {
    case 'R': _model = HARD_RESTRICTION; break;
    case 'P': _model = PRICE_ORIENTED; break;
    case 'H': _model = HYBRID; break;
    default: _model = LAST_VALUE; break;
    }

    if (_model == LAST_VALUE) {
      const std::string& lLabels = describeLabels();
      std::ostringstream oMessage;
      oMessage << "The passenger choice model '"
               << "' is not known. Known passenger choice models " << lLabels;
      throw stdair::CodeConversionException (oMessage.str());
    }
  }
  
  // //////////////////////////////////////////////////////////////////////
  const std::string& PassengerChoiceModel::
  getLabel (const EN_PassengerChoiceModel& iModel) {
    return _labels[iModel];
  }
  
  // //////////////////////////////////////////////////////////////////////
  char PassengerChoiceModel::getModelLabel (const EN_PassengerChoiceModel& iModel) {
    return _modelLabels[iModel];
  }

  // //////////////////////////////////////////////////////////////////////
  std::string PassengerChoiceModel::
  getModelLabelAsString (const EN_PassengerChoiceModel& iModel) {
    std::ostringstream oStr;
    oStr << _modelLabels[iModel];
    return oStr.str();
  }

  // //////////////////////////////////////////////////////////////////////
  std::string PassengerChoiceModel::describeLabels() {
    std::ostringstream ostr;
    for (unsigned short idx = 0; idx != LAST_VALUE; ++idx) {
      if (idx != 0) {
        ostr << ", ";
      }
      ostr << _labels[idx] << " (" << _modelLabels[idx] << ")";
    }
    return ostr.str();
  }

  // //////////////////////////////////////////////////////////////////////
  PassengerChoiceModel::EN_PassengerChoiceModel PassengerChoiceModel::getModel() const {
    return _model;
  }
  
  // //////////////////////////////////////////////////////////////////////
  std::string PassengerChoiceModel::getModelAsString() const {
    std::ostringstream oStr;
    oStr << _modelLabels[_model];
    return oStr.str();
  }
  
  // //////////////////////////////////////////////////////////////////////
  const std::string PassengerChoiceModel::describe() const {
    std::ostringstream ostr;
    ostr << _labels[_model];
    return ostr.str();
  }

  // //////////////////////////////////////////////////////////////////////
  bool PassengerChoiceModel::
  operator== (const EN_PassengerChoiceModel& iModel) const {
    return (_model == iModel);
  }
  
}
