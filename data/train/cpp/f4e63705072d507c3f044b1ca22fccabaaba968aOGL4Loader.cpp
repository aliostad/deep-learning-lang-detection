#include "ogl4graphics_pch.h"
#include "../OGL4Loader.h"

#if defined (__APPLE__)
#include <regex>
#include <algorithm>



#define LOAD_API(api, type)

namespace ld3d
{
	OGL4Loader::OGL4Loader(void)
	{
		m_hLib = nullptr;
	}


	OGL4Loader::~OGL4Loader(void)
	{
	}
	bool OGL4Loader::load_module()
	{
		
		return true;
		
	}
	void* OGL4Loader::_load(const char* szName)
	{
		return nullptr;
	}
	bool OGL4Loader::Load()
	{
		if(load_module() == false)
		{
			return false;
		}

		if(load_wgl() == false)
		{
			return false;
		}

		if(false == load_version())
		{
			return false;
		}

		if(false == load_extension_info())
		{
			return false;
		}

		if(false == load_api())
		{
			return false;
		}


		return true;
	}
	bool OGL4Loader::load_wgl()
	{
		
		return true;
	}
	bool OGL4Loader::load_version()
	{

		LOAD_API(glGetString,										PFNGLGETSTRINGPROC);

		int major;
		int minor;
		GLubyte const * str = glGetString(GL_VERSION);
		if (str != NULL)
		{
			std::string const ver(reinterpret_cast<char const *>(str));
			std::string::size_type const pos(ver.find("."));

			major = ver[pos - 1] - '0';
			minor = ver[pos + 1] - '0';
		}
		else
		{
			// GL context has not actived yet
			major = minor = -1;
		}

		m_ver = Version(major, minor, 0, 0);

		return true;
	}
	bool OGL4Loader::load_extension_info()
	{
		LOAD_API(glGetStringi, PFNGLGETSTRINGIPROC);
		LOAD_API(glGetIntegerv, PFNGLGETINTEGERVPROC);

		if(glGetStringi == nullptr)
		{
			return false;
		}
		GLint num_exts;
		glGetIntegerv(GL_NUM_EXTENSIONS, &num_exts);
		for (GLint i = 0; i < num_exts; ++ i)
		{
			const char* szExt = (const char*)glGetStringi(GL_EXTENSIONS, i);

			m_exts.push_back(szExt);
		}

		return true;
	}
	void OGL4Loader::Unload()
	{
		m_exts.clear();

		os_unload_module(m_hLib);
		m_hLib = nullptr;
	}
	bool OGL4Loader::IsExtSupported(const std::string& ext)
	{
		return m_exts.end() != std::find(m_exts.begin(), m_exts.end(), ext);
	}
	bool OGL4Loader::load_api()
	{
		
		LOAD_API(glGetStringi,											PFNGLGETSTRINGIPROC);
		LOAD_API(glGetString,											PFNGLGETSTRINGPROC);
		LOAD_API(glGetIntegerv,											PFNGLGETINTEGERVPROC);
		LOAD_API(glDeleteTextures,										PFNGLDELETETEXTURESPROC);
		LOAD_API(glGenTextures,											PFNGLGENTEXTURESPROC);

		LOAD_API(glBindTexture,											PFNGLBINDTEXTUREPROC);
		LOAD_API(glTexParameteri,										PFNGLTEXPARAMETERIPROC);
		LOAD_API(glTexSubImage1D,										PFNGLTEXSUBIMAGE1DPROC);
		LOAD_API(glTexSubImage2D,										PFNGLTEXSUBIMAGE2DPROC);

		LOAD_API(glEnable,												PFNGLENABLEPROC);
		LOAD_API(glDisable,												PFNGLDISABLEPROC);
		LOAD_API(glColorMask,											PFNGLCOLORMASKPROC);
		LOAD_API(glPolygonMode,											PFNGLPOLYGONMODEPROC);

		LOAD_API(glCullFace,											PFNGLCULLFACEPROC);
		LOAD_API(glFrontFace,											PFNGLFRONTFACEPROC);
		LOAD_API(glPolygonOffset,										PFNGLPOLYGONOFFSETPROC);
		LOAD_API(glDepthMask,											PFNGLDEPTHMASKPROC);

		LOAD_API(glDepthFunc,											PFNGLDEPTHFUNCPROC);
		LOAD_API(glDrawArrays,											PFNGLDRAWARRAYSPROC);
		LOAD_API(glDrawElements,										PFNGLDRAWELEMENTSPROC);
		LOAD_API(glViewport,											PFNGLVIEWPORTPROC);


		LOAD_API(glGenBuffers,											PFNGLGENBUFFERSPROC);

		LOAD_API(glBindBuffer,											PFNGLBINDBUFFERPROC);
		LOAD_API(glBufferData,											PFNGLBUFFERDATAPROC);


		LOAD_API(glEnableVertexAttribArray,								PFNGLENABLEVERTEXATTRIBARRAYPROC);
		LOAD_API(glDisableVertexAttribArray,							PFNGLDISABLEVERTEXATTRIBARRAYPROC);
		LOAD_API(glIsBuffer,											PFNGLISBUFFERPROC);

		LOAD_API(glBufferSubData,										PFNGLBUFFERSUBDATAPROC);
		LOAD_API(glMapBufferRange,										PFNGLMAPBUFFERRANGEPROC);
		LOAD_API(glUnmapBuffer,											PFNGLUNMAPBUFFERPROC);
		LOAD_API(glDeleteBuffers,										PFNGLDELETEBUFFERSPROC);
		LOAD_API(glBindVertexBuffer,									PFNGLBINDVERTEXBUFFERPROC);

		LOAD_API(glVertexAttribPointer,									PFNGLVERTEXATTRIBPOINTERPROC);


		LOAD_API(glClearBufferfv,										PFNGLCLEARBUFFERFVPROC);
		LOAD_API(glClearBufferfi,										PFNGLCLEARBUFFERFIPROC);
		LOAD_API(glClearBufferiv,										PFNGLCLEARBUFFERIVPROC);
		
		LOAD_API(glDebugMessageControl,									PFNGLDEBUGMESSAGECONTROLPROC);
		LOAD_API(glDebugMessageInsert,									PFNGLDEBUGMESSAGEINSERTPROC);
		LOAD_API(glDebugMessageCallback,								PFNGLDEBUGMESSAGECALLBACKPROC);
		LOAD_API(glGetDebugMessageLog,									PFNGLGETDEBUGMESSAGELOGPROC);


		LOAD_API(glTexImage3D,											PFNGLTEXIMAGE3DPROC);
		LOAD_API(glGenerateMipmap,										PFNGLGENERATEMIPMAPPROC);
		LOAD_API(glActiveTexture,										PFNGLACTIVETEXTUREPROC);


		LOAD_API(glGenVertexArrays,										PFNGLGENVERTEXARRAYSPROC);
		LOAD_API(glBindVertexArray,										PFNGLBINDVERTEXARRAYPROC);
		LOAD_API(glDeleteVertexArrays,									PFNGLDELETEVERTEXARRAYSPROC);


		LOAD_API(glCreateProgram,										PFNGLCREATEPROGRAMPROC);
		LOAD_API(glDeleteProgram,										PFNGLDELETEPROGRAMPROC);
		LOAD_API(glLinkProgram,											PFNGLLINKPROGRAMPROC);
		LOAD_API(glUseProgram,											PFNGLUSEPROGRAMPROC);

		LOAD_API(glCreateShader,										PFNGLCREATESHADERPROC);
		LOAD_API(glDeleteShader,										PFNGLDELETESHADERPROC);
		LOAD_API(glShaderSource,										PFNGLSHADERSOURCEPROC);
		LOAD_API(glCompileShader,										PFNGLCOMPILESHADERPROC);
		LOAD_API(glAttachShader,										PFNGLATTACHSHADERPROC);
		LOAD_API(glDetachShader,										PFNGLDETACHSHADERPROC);


		LOAD_API(glGetProgramiv,										PFNGLGETPROGRAMIVPROC);
		LOAD_API(glGetProgramInfoLog,									PFNGLGETPROGRAMINFOLOGPROC);
		LOAD_API(glValidateProgram,										PFNGLVALIDATEPROGRAMPROC);
		LOAD_API(glGetShaderiv,											PFNGLGETSHADERIVPROC);
		LOAD_API(glGetShaderInfoLog,									PFNGLGETSHADERINFOLOGPROC);

		LOAD_API(glBindBufferRange,										PFNGLBINDBUFFERRANGEPROC);
		LOAD_API(glBindBufferBase,										PFNGLBINDBUFFERBASEPROC);

		LOAD_API(glGetUniformBlockIndex,								PFNGLGETUNIFORMBLOCKINDEXPROC);
		LOAD_API(glUniformBlockBinding,									PFNGLUNIFORMBLOCKBINDINGPROC);

		LOAD_API(glGetActiveUniformBlockiv,								PFNGLGETACTIVEUNIFORMBLOCKIVPROC);
		LOAD_API(glGetActiveUniformBlockName,							PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC);

		LOAD_API(glGetActiveUniformsiv,									PFNGLGETACTIVEUNIFORMSIVPROC);
		LOAD_API(glGetUniformLocation,									PFNGLGETUNIFORMLOCATIONPROC);


		LOAD_API(glProgramUniform1f,									PFNGLPROGRAMUNIFORM1FPROC);
		LOAD_API(glProgramUniform1i,									PFNGLPROGRAMUNIFORM1IPROC);
		LOAD_API(glProgramUniform1ui,									PFNGLPROGRAMUNIFORM1UIPROC);

		LOAD_API(glProgramUniform2fv,									PFNGLPROGRAMUNIFORM2FVPROC);
		LOAD_API(glProgramUniform3fv,									PFNGLPROGRAMUNIFORM3FVPROC);
		LOAD_API(glProgramUniform4fv,									PFNGLPROGRAMUNIFORM4FVPROC);

		LOAD_API(glProgramUniform2iv,									PFNGLPROGRAMUNIFORM2IVPROC);
		LOAD_API(glProgramUniform3iv,									PFNGLPROGRAMUNIFORM3IVPROC);
		LOAD_API(glProgramUniform4iv,									PFNGLPROGRAMUNIFORM4IVPROC);

		LOAD_API(glProgramUniform2uiv,									PFNGLPROGRAMUNIFORM2UIVPROC);
		LOAD_API(glProgramUniform3uiv,									PFNGLPROGRAMUNIFORM3UIVPROC);
		LOAD_API(glProgramUniform4uiv,									PFNGLPROGRAMUNIFORM4UIVPROC);

		LOAD_API(glProgramUniformMatrix4fv,								PFNGLPROGRAMUNIFORMMATRIX4FVPROC);

		LOAD_API(glTexStorage1D,										PFNGLTEXSTORAGE1DPROC);
		LOAD_API(glTexStorage2D,										PFNGLTEXSTORAGE2DPROC);
		LOAD_API(glTexStorage2DMultisample,								PFNGLTEXSTORAGE2DMULTISAMPLEPROC);
		LOAD_API(glTexStorage3D,										PFNGLTEXSTORAGE3DPROC);

		LOAD_API(glTexSubImage3D,										PFNGLTEXSUBIMAGE3DPROC);

		LOAD_API(glGenSamplers,											PFNGLGENSAMPLERSPROC);
		LOAD_API(glDeleteSamplers,										PFNGLDELETESAMPLERSPROC);
		LOAD_API(glSamplerParameteri,									PFNGLSAMPLERPARAMETERIPROC);
		LOAD_API(glSamplerParameterf,									PFNGLSAMPLERPARAMETERFPROC);
		LOAD_API(glSamplerParameteriv,									PFNGLSAMPLERPARAMETERIVPROC);
		LOAD_API(glSamplerParameterfv,									PFNGLSAMPLERPARAMETERFVPROC);

		LOAD_API(glBindSampler,											PFNGLBINDSAMPLERPROC);
		LOAD_API(glGetSamplerParameteriv,								PFNGLGETSAMPLERPARAMETERIVPROC);

		LOAD_API(glGenRenderbuffers,									PFNGLGENRENDERBUFFERSPROC);
		LOAD_API(glDeleteRenderbuffers,									PFNGLDELETERENDERBUFFERSPROC);
		LOAD_API(glRenderbufferStorage,									PFNGLRENDERBUFFERSTORAGEPROC);
		LOAD_API(glRenderbufferStorageMultisample,									PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC);
		
		LOAD_API(glBindRenderbuffer,									PFNGLBINDRENDERBUFFERPROC);

		LOAD_API(glGenFramebuffers,										PFNGLGENFRAMEBUFFERSPROC);
		LOAD_API(glDeleteFramebuffers,									PFNGLDELETEFRAMEBUFFERSPROC);
		LOAD_API(glBindFramebuffer,										PFNGLBINDFRAMEBUFFERPROC);
		LOAD_API(glCheckFramebufferStatus,								PFNGLCHECKFRAMEBUFFERSTATUSPROC);
		LOAD_API(glFramebufferTexture,									PFNGLFRAMEBUFFERTEXTUREPROC);
		LOAD_API(glFramebufferRenderbuffer,								PFNGLFRAMEBUFFERRENDERBUFFERPROC);


		LOAD_API(glBlendColor,											PFNGLBLENDCOLORPROC);
		LOAD_API(glStencilOpSeparate,									PFNGLSTENCILOPSEPARATEPROC);

		LOAD_API(glBlendEquationSeparate,								PFNGLBLENDEQUATIONSEPARATEPROC);
		LOAD_API(glBlendFuncSeparate,									PFNGLBLENDFUNCSEPARATEPROC);
		LOAD_API(glStencilMaskSeparate,									PFNGLSTENCILMASKSEPARATEPROC);
		LOAD_API(glStencilFuncSeparate,									PFNGLSTENCILFUNCSEPARATEPROC);

		LOAD_API(glDrawBuffers,											PFNGLDRAWBUFFERSPROC);

		LOAD_API(glCompressedTexSubImage2D,								PFNGLCOMPRESSEDTEXSUBIMAGE2DPROC);

		LOAD_API(glCompressedTexSubImage3D,								PFNGLCOMPRESSEDTEXSUBIMAGE3DPROC);

		return true;
	}
	const std::vector<std::string>& OGL4Loader::GetExt()
	{
		return m_exts;
	}
}

#endif
