////////////////////////////////////////////////////////////////////////
//  File Name          : rd3_resloader.h
//  Created            : 30 1 2012   19:09
//  Author             : Alexandru Motriuc  
//  File Path          : SLibF\engine3d\include
//  System independent : 0%
//  Library            : 
//
//  Purpose:	
//    
//
/////////////////////////////////////////////////////////////////////////
//  Modification History :
// 
/////////////////////////////////////////////////////////////////////////

#ifndef _RD3_RESLOADER_H_
#define _RD3_RESLOADER_H_

#ifndef _RD3_CONF_H_
	#error rd3_conf.h must be included
#endif

#include "rd3_types.h"

namespace Rd3 
{

using namespace System;
	
//////////////////////////////////////////////////////
// ResourceLoader schema 
//////////////////////////////////////////////////////
// <>
//		<texture name="..." path="..."/>
//
// </>

/**
 * ResourceLoader
 */
class ResourceLoader
{
public:
	ResourceLoader();
	
	~ResourceLoader();
	
	/**
	 *
	 */
	void LoadFromXML( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	
	/**
	 *
	 */
	void LoadFromFile( const sString& path, ResLoadParams& loadParams ) throws_error;
	
	/**
	 *
	 */
	void FreeResources();
private:
	sVector<ResourceObject*>	_loadedResources;
private:
	void LoadTexture( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	void LoadEffect( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	void LoadMesh( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	void LoadVBuffer( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	void LoadIBuffer( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	void LoadAfterEffect( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	void LoadFont( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
	void LoadAnimation( const Xml::BaseDomNode& element, ResLoadParams& loadParams ) throws_error;
};

}
#endif // _RD3_RESLOADER_H_
