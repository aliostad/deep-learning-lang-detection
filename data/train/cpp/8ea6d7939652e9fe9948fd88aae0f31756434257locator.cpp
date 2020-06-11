#include "../common.h"

#include "locator.h"

using namespace gamefw;

FileService* Locator::s_file_service;
ShaderFactory* Locator::s_shader_factory;

FileService& Locator::getFileService()
{
    assert(s_file_service != NULL);
    return *s_file_service;
}

void Locator::registerFileService(FileService& service)
{
    s_file_service = &service;
}

ShaderFactory& Locator::getShaderFactory()
{
    assert(s_shader_factory != NULL);
    return *s_shader_factory;
}

void Locator::registerShaderFactory(ShaderFactory& service)
{
    s_shader_factory = &service;
}



