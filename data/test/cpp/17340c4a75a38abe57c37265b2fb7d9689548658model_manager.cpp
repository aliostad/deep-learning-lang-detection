#include "model_manager.h"


ModelManager::ModelManager()
{
    for (const auto& prefix : model_prefixes) {
        _models[prefix] = ModelFactory::create_model(prefix);
    }
}
ModelManager::~ModelManager()
{
    for (const auto& prefix : model_prefixes) {
        delete _models[prefix];
    }
}

Model* ModelManager::get_model_by_prefix(std::string prefix)
{
    return _models[prefix];
}


Model* ModelFactory::create_model(const std::string& prefix)
{
    if (prefix == "si")
        return _create_accelerator_model(prefix);
    else if (prefix == "bo")
        return _create_accelerator_model(prefix);
    else
        throw std::invalid_argument("invalid model prefix");
}

Model* ModelFactory::_create_accelerator_model(const std::string &prefix)
{
    std::string file_name("/home/fac_files/siriusdb/vacpp/"+prefix+".txt");
    return new AcceleratorModel(file_name);
}
