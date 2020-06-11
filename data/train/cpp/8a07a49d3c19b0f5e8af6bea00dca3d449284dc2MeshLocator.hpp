/**
 *  Resource/MeshLocator.hpp
 *  (c) Jonathan Capps
 *  Created 19 Sept. 2011
 */

#ifndef MESH_LOCATOR_HPP
#define MESH_LOCATOR_HPP

#include <string>
#include <vector>
#include "MeshResource.hpp"
#include "../Entity/Entity.hpp"

class GFXDevice;
class MeshCache;
class MeshLocator
{
	public:
		MeshLocator();
		MeshLocator( GFXDevice& debice );
		MeshResource& Request( const std::string& filename );
		MeshResource* RequestPtr( const std::string& filename );
		static void ShutDown();

	private:
		MeshLocator( const MeshLocator& );
		MeshLocator& operator=( const MeshLocator& );

		static MeshCache*	_cache;
};

#endif //MESH_LOCATOR_HPP
