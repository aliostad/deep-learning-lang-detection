/**
 *
 **/

#include "MainModel.h"

namespace Carta
{
namespace Hacks
{
namespace Model
{

MainModel::MainModel(PluginManager::SharedPtr pm, QObject * parent)
    : QObject( parent)
{
    setPluginManager(pm);
}

MainModel::~MainModel()
{ }
}

GlobalsH * GlobalsH::m_instance = nullptr;

GlobalsH & GlobalsH::instance() {
    if( ! m_instance) {
        m_instance = new GlobalsH;
    }
    CARTA_ASSERT( m_instance);
    return * m_instance;
}

Model::MainModel & GlobalsH::mainModel()
{
    CARTA_ASSERT( m_pluginManager);
    if( ! m_mainModel) {
//        m_mainModel = std::make_shared<Model::MainModel>( m_pluginManager);
        m_mainModel.reset( new Model::MainModel( m_pluginManager));
    }
    return * m_mainModel;
}

GlobalsH::GlobalsH()
{

}

}
}

