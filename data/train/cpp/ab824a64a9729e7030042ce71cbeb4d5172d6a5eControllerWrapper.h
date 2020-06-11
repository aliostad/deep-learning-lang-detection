#pragma once


#include "ObjectWrapper.h"
#include "../framework/Controller.h"
#include "../framework/controller/LoadGeometry.h"
#include "../framework/controller/LoadVolume.h"
#include "../framework/controller/LoadTexture.h"
#include "../framework/controller/LoadShader.h"


namespace gui
{

	class ControllerWrapper : public ObjectWrapper
	{
		Q_OBJECT
	public:
		typedef std::shared_ptr<ControllerWrapper> Ptr;

		ControllerWrapper( Controller::Ptr controller );
		virtual ~ControllerWrapper();
		static Ptr create( Controller::Ptr controller );

	private:
		Controller::Ptr m_controller;
	};

	class LoadGeometryWrapper : public ControllerWrapper
	{
		Q_OBJECT
	public:
		typedef std::shared_ptr<LoadGeometryWrapper> Ptr;

		LoadGeometryWrapper( LoadGeometry::Ptr controller );
		virtual ~LoadGeometryWrapper();
		static Ptr create( LoadGeometry::Ptr controller );

		void setFilename( const std::string& filename );
		std::string getFilename();
		void reload();

	private:
		LoadGeometry::Ptr m_loadGeometry;
	};

	class LoadVolumeWrapper : public ControllerWrapper
	{
		Q_OBJECT
	public:
		typedef std::shared_ptr<LoadVolumeWrapper> Ptr;

		LoadVolumeWrapper( LoadVolume::Ptr controller );
		virtual ~LoadVolumeWrapper();
		static Ptr create( LoadVolume::Ptr controller );

		void setFilename( const std::string& filename );
		std::string getFilename();
		void reload();

	private:
		LoadVolume::Ptr m_loadVolume;
	};

	class LoadTexture2dWrapper : public ControllerWrapper
	{
		Q_OBJECT
	public:
		typedef std::shared_ptr<LoadTexture2dWrapper> Ptr;

		LoadTexture2dWrapper( LoadTexture2d::Ptr controller );
		virtual ~LoadTexture2dWrapper();
		static Ptr create( LoadTexture2d::Ptr controller );

		void setFilename( const std::string& filename );
		std::string getFilename();

		void reload();

	private:
		LoadTexture2d::Ptr m_loadTexture2d;
	};


	class LoadShaderWrapper : public ControllerWrapper
	{
		Q_OBJECT
	public:
		typedef std::shared_ptr<LoadShaderWrapper> Ptr;

		LoadShaderWrapper( LoadShader::Ptr loadShader );
		virtual ~LoadShaderWrapper();
		static Ptr create( LoadShader::Ptr loadShader );

		void setFilename( const std::string& filename );
		std::string getFilename();

		void reload();

	private:
		LoadShader::Ptr m_loadShader;
	};


} // namespace gui
