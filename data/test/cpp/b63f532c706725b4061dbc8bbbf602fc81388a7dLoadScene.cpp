#include "LoadScene.h"

LoadScene::LoadScene(void)
{
	m_nextScene = nullptr;
	//m_loading = nullptr;
}

LoadScene::~LoadScene(void)
{
}

bool LoadScene::Initialize(void)
{
	m_nextScene = new TestScene();

	m_thread = std::thread(LoadNextScene, this);

	m_thread.detach();

	//m_loading = new Engine::Text();
	//m_loading->Initialize(L"Loading...", 300.f, 300.f);
	//m_loading->SetColour(Engine::WHITE);

	return true;
}

void LoadScene::LoadNextScene(void* caller)
{
	LoadScene *pCaller = (LoadScene*)caller;

	pCaller->m_nextScene->Initialize();
}

void LoadScene::Render2D(void)
{
	//m_loading->Render();

	if(!m_thread.joinable())
	{
		//Engine::Overlord::GetInstance()->SetScene(m_nextScene);
	}
}