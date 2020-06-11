#ifndef MODEL_DAO_TEMPLATE_H
#define MODEL_DAO_TEMPLATE_H

#include <Common/Common.h>
#include <Dao/Engine/Connection.h>
#include <Dao/Engine/AbstractDAO.h>

using query_row = pqxx::result::const_iterator;

namespace DAO {

template <typename Model, typename Dependencies = NoDependencies, typename ModelDependencies = NoModelDependencies>
class ModelDAOTemplate : public AbstractDAO<Model, ModelDAOTemplate<Model, Dependencies, ModelDependencies>>{
private:
	Dependencies      dependencies;
	ModelDependencies modelDependencies;
	ModelDAOTemplate* parseResult(query_row);

public:
	ModelDAOTemplate(                            );
	ModelDAOTemplate(int                         );
	ModelDAOTemplate(const ModelDAOTemplate&     );
	ModelDAOTemplate(shared_ptr<ModelDAOTemplate>);

	ModelDAOTemplate(shared_ptr<Model>                                       , int = 0);
	ModelDAOTemplate(shared_ptr<Model>,               shared_ptr<Connection>&, int = 0);
	ModelDAOTemplate(shared_ptr<Model>, Dependencies                         , int = 0);
	ModelDAOTemplate(shared_ptr<Model>, Dependencies, shared_ptr<Connection>&, int = 0);

	const string& getAllQuery             ();
	const string& getByIdQuery            ();
	const string& getDeleteQuery          ();
	const string& getInsertQuery          ();
	const string& getUpdateQuery          ();
	const string& getSerialization        ();
	const string& getTableCreationQuery   ();
	const string& getFindByAttributesQuery();

 protected:
	void initializeFunctors();
	
	template <typename D>string synchronizeDependency(bool serialization);
	template <typename D, typename R>function<shared_ptr<R>()> depend_getter();

	static const string INSERT_QUERY            ;
	static const string UPDATE_QUERY            ;
	static const string DELETE_QUERY            ;
	static const string GET_ALL_QUERY           ;
	static const string SERIALIZATION           ;
	static const string GET_BY_ID_QUERY         ;
	static const string GET_BY_ATTRIBUTES_QUERY ;
	static const string GET_TABLE_CREATION_QUERY;
};

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(){
    this->id = 0;
    this->initializeFunctors();
}

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(int id){
	this->id         = id;
	this->connection = make_shared<Connection>(Connection());
    this->initializeFunctors();
	auto x = this->getById(id);
	this->model      = x->model;
}

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(shared_ptr<ModelDAOTemplate> modelDAOTemplate){
	this->id           = modelDAOTemplate->id;
	this->model        = modelDAOTemplate->model;
	this->connection   = modelDAOTemplate->connection;
	this->dependencies = modelDAOTemplate->dependencies;
    this->initializeFunctors();
}

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(const ModelDAOTemplate& modelDAOTemplate){
	this->id         = modelDAOTemplate.id;
	this->model      = make_shared<ModelDAOTemplate>(*modelDAOTemplate.model);
	this->connection = make_shared<Connection>(Connection());
    this->initializeFunctors();
}

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(shared_ptr<Model> model, int id){
	this->id           = id ;
	this->model        = model;
	this->connection   = make_shared<Connection>(Connection());
    this->initializeFunctors();
}

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(shared_ptr<Model> model, shared_ptr<Connection>& connection, int id){
	this->id           = id ;
	this->model        = model;
	this->connection   = connection;
    this->initializeFunctors();
}

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(shared_ptr<Model> model, Dependencies dependencies, int id){
	this->id           = id ;
	this->model        = model;
	this->connection   = make_shared<Connection>(Connection());
	this->dependencies = dependencies;
    this->initializeFunctors();
}

template <typename Model, typename Dependencies, typename ModelDependencies>
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::ModelDAOTemplate(shared_ptr<Model> model, Dependencies dependencies, shared_ptr<Connection>& connection, int id){
	this->id           = id ;
	this->model        = model;
	this->connection   = connection;
	this->dependencies = dependencies;
    this->initializeFunctors();
}

template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getAllQuery             () { return this->GET_ALL_QUERY           ;}
template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getByIdQuery            () { return this->GET_BY_ID_QUERY         ;}
template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getDeleteQuery          () { return this->DELETE_QUERY            ;}
template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getInsertQuery          () { return this->INSERT_QUERY            ;}
template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getUpdateQuery          () { return this->UPDATE_QUERY            ;}
template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getSerialization        () { return this->SERIALIZATION           ;}
template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getTableCreationQuery   () { return this->GET_TABLE_CREATION_QUERY;}
template <typename Model, typename Dependencies, typename ModelDependencies> const string& ModelDAOTemplate<Model, Dependencies, ModelDependencies>::getFindByAttributesQuery() { return this->GET_BY_ATTRIBUTES_QUERY ;}

template <typename Model, typename Dependencies, typename ModelDependencies>
template <typename D>
string ModelDAOTemplate<Model, Dependencies, ModelDependencies>::synchronizeDependency(bool serialization){
	if(boost::fusion::has_key<D>(this->dependencies)){
		auto depend = boost::fusion::at_key<D>(this->dependencies);
		using innerModelDAO = typename D::first;
		using innerModel    = typename innerModelDAO::modelType;
		if(depend == nullptr){
			depend = shared_ptr<innerModelDAO>(new innerModelDAO(depend_getter<D, innerModel>()()));
			if(depend->synchronizeToDB() == 0){
				throw "Synchronization failed : failed to synchronize with db";
		}}
		if(serialization)
			return *(depend->serialize());
		return to_string(depend->getId());
	}
	throw "Synchronization failed : requested dependency not found";
}

template <typename Model, typename Dependencies, typename ModelDependencies>
template<typename D, typename R>
function<shared_ptr<R>()> 
ModelDAOTemplate<Model, Dependencies, ModelDependencies>::depend_getter(){
	if(boost::fusion::has_key<D>(this->modelDependencies)){
		return boost::fusion::at_key<D>(this->modelDependencies);
	}
	throw "get_getter failed, required type not found";
}

}

#endif