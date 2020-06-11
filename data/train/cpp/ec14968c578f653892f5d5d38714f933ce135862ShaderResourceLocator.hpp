#ifndef CW_OPENGL_SHADER_RESOURCE_LOCATOR_HPP_INC
#define CW_OPENGL_SHADER_RESOURCE_LOCATOR_HPP_INC

#include <GL/glew.h>
#include <glm/glm.hpp>

#include <string>

namespace cw
{
  namespace opengl
  {
    class ShaderResourceLocator
    {
      public:
        ShaderResourceLocator(GLuint programId);
        ~ShaderResourceLocator();

        GLuint getUniform( const char * name ) const;
        GLuint getAttrib( const char * name ) const;

        void setUniform( const char * name, float value );
        void setUniform( const char * name, const glm::vec3 & value );

      private:
        ShaderResourceLocator(ShaderResourceLocator&);
        void operator=(ShaderResourceLocator);

        GLuint m_programId;

        int checkedLocation( int location, const std::string & locationName ) const;
    };
  }
}
#endif
