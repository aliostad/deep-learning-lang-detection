#include "Sample_Task.h"
#include "base/EngineBase.h"
#include "Sample/BufferAndShaderSample.h"
#include "Sample/TextureSample.h"
#include "Sample/ModleLoaderSample.h"
#include "Sample/XMLTestSample.h"
#include "Sample/TextureUITest.h"
#include "Sample/FrontTestSample.h"
#include "Sample/RTTSample.h"
#include "Sample/TerrainSample.h"
#include "Sample/TexProjectSample.h"
#include "Sample/ShadowMapSample.h"
Sample_Task::Sample_Task(void):m_psample(NULL)
{
	MainTaskManager::Instance().add(TASK_SAMPLE, this);
}

Sample_Task::~Sample_Task(void)
{
	MainTaskManager::Instance().del(TASK_SAMPLE);
}

bool Sample_Task::init()
{
	m_psample = new ShadowMapSample();
	if(NULL != m_psample)
		return m_psample->init();
	return false;
}

void Sample_Task::fini()
{
	m_psample->fini();
	SAFE_DELETE(m_psample);
}

void Sample_Task::update( float det )
{
	if(NULL != m_psample)
		m_psample->update(det);
}

bool Sample_Task::render()
{
	if(NULL != m_psample)
		return  m_psample->render();
	return true;

}