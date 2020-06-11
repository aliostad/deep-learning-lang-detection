#include "ModelBuilderBase.h"

using namespace nspace;

ModelNode * ModelBuilderBase::createNode(){return new ModelNode;};
Connection * ModelBuilderBase::createConnection(){return new Connection;}
Connector * ModelBuilderBase::createConnector(){return new Connector;}

const Set<Model*> ModelBuilderBase::models()const{
  return _models;
}

ModelBuilderBase::ModelBuilderBase(){
  reset();
}
void ModelBuilderBase::reset(){
  _currentModel=0;
  _currentElement=0;
}
Model * ModelBuilderBase::currentModel(){
  return _currentModel;
}
Model * ModelBuilderBase::beginModel(){
  _currentModel = new Model();
  addElement(_currentModel);
  _models.add(_currentModel);
  return _currentModel;
}
Model * ModelBuilderBase::endModel(){
  buildModel(*_currentModel);
  Model * model = _currentModel;

  _currentModel =0;
  return model;
}
ModelNode * ModelBuilderBase::addNode(){
  ModelNode * node = createNode();
  //addElement(node);
  _currentModel->nodes().add(node);
  return node;
}
Connector * ModelBuilderBase::addConnector(const std::string & nodeName){
  return 0;
}
Connection * ModelBuilderBase::addConnection(const std::string & nodeAm, const std::string & nodeB){
  Connection * connection = createConnection();
  //   addElement(connection);
  //      _currentModel->connections().add(connection);
  return connection;
}

ModelElement * ModelBuilderBase::element(const std::string  &name){
  return Query<ModelElement*>::selectFirst(elements(),[&name](ModelElement* element){return element->name()==name;});
}
void ModelBuilderBase::addElement(ModelElement * element){
  _currentElement = element;
  Set<ModelElement*>::add(element);
}