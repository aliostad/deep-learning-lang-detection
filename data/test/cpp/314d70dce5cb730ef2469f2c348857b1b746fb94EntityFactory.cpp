#include <back/EntityFactory.hpp>

#include <back/global/Components.hpp>
#include <game/TestComponent.hpp>


using namespace std;


EntityFactory::EntityFactory()
{}


void EntityFactory::addComponent( const string& type, ComponentBuilder builder )
{
  if( componentRepo.find( type ) == componentRepo.end() )
    componentRepo[ type ] = builder;
}


Component* EntityFactory::getComponent( const string& type )
{
  if( componentRepo.find( type ) != componentRepo.end() )
    return componentRepo[ type ]();

  return NULL;
}
