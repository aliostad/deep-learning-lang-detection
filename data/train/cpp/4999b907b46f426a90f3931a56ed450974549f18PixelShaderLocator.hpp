/**
 *  Resource/PixelShaderLocator.hpp
 *  (c) Jonathan Capps
 *  Created 16 Sept. 2011
 */

#ifndef PIXEL_SHADER_LOCATOR_HPP
#define PIXEL_SHADER_LOCATOR_HPP

#include <string>
#include "PixelShaderResource.hpp"

class GFXDevice;
class PixelShaderCache;
class PixelShaderLocator
{
	public:
		PixelShaderLocator( GFXDevice& device );

		PixelShaderResource& Request( const std::string& filename,
					  const std::string& shader );
		PixelShaderResource* RequestPtr( const std::string& filename,
					  const std::string& shader );
		static void ShutDown();

	private:
		PixelShaderLocator( const PixelShaderLocator& );
		PixelShaderLocator& operator=( const PixelShaderLocator& );

		static PixelShaderCache*	_cache;
};

#endif //PIXEL_SHADER_LOCATOR_HPP
