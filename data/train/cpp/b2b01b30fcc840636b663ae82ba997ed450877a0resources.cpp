#include <pch.hpp>
#include "../../include/core/resources.hpp"
#include "../../include/core/actor/actor.hpp"
namespace hp_fp
{
	Maybe<Model>& getModel_IO( Renderer& renderer, Resources& resources,
		const LoadedModelDef& modelDef )
	{
		if ( resources.loadedModels.count( modelDef ) == 0 )
		{
			resources.loadedModels.emplace( modelDef, loadModelFromFile_IO( renderer,
				modelDef.filename, modelDef.scale ) );
		}
		return resources.loadedModels.at( modelDef );
	}
	Maybe<Model>& getModel_IO( Renderer& renderer, Resources& resources,
		const BuiltInModelDef& modelDef )
	{
		if ( resources.builtInModels.count( modelDef ) == 0 )
		{
			switch ( modelDef.type )
			{
			case BuiltInModelType::Cube:
			{
				resources.builtInModels.emplace( modelDef,
					cubeMesh_IO( renderer, modelDef.dimensions ) );
			}
			break;
			default:
				WAR( "Missing built-In model for type " +
					std::to_string( static_cast<UInt8>( modelDef.type ) ) + "." );
			}
		}
		return resources.builtInModels.at( modelDef );
	}
	Maybe<Material>& getMaterial_IO( Renderer& renderer, Resources& resources,
		const MaterialDef& materialDef )
	{
		if ( resources.materials.count( materialDef ) == 0 )
		{
			resources.materials.emplace( materialDef, loadMaterial_IO( renderer, materialDef ) );
		}
		return resources.materials.at( materialDef );
	}
	Maybe<ActorResources> getActorResources_IO( Renderer& renderer, Resources& resources,
		const ActorModelDef& actorModelDef )
	{
		if ( actorModelDef.model.is<LoadedModelDef>( ) )
		{
			Maybe<Model>& model = getModel_IO( renderer, resources,
				actorModelDef.model.loaded );
			return getMaterialForModel_IO( renderer, resources, model,
				actorModelDef.material );
		}
		else if ( actorModelDef.model.is<BuiltInModelDef>( ) )
		{
			Maybe<Model>& model = getModel_IO( renderer, resources,
				actorModelDef.model.builtIn );
			return getMaterialForModel_IO( renderer, resources, model,
				actorModelDef.material );
		}
		return nothing<ActorResources>( );
	}
	namespace
	{
		Maybe<ActorResources> getMaterialForModel_IO( Renderer& renderer, Resources& resources,
			Maybe<Model>& model, const MaterialDef& materialDef )
		{
			return ifThenElse( model, [&renderer, &resources, &materialDef]( Model& model )
			{
				Maybe<Material>& material = getMaterial_IO( renderer, resources, materialDef );
				return ifThenElse( material, [&model]( Material& material )
				{
					return just( ActorResources{ model, material } );
				}, []
				{
					return nothing<ActorResources>( );
				} );
			}, []
			{
				return nothing<ActorResources>( );
			} );
		}
	}
}

