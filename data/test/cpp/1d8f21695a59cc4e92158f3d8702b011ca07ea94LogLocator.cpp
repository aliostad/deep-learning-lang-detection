#include "LogLocator.h"

namespace Service
{
	CLogLocator* CLogLocator::m_pInstance = nullptr;

	CLogLocator* CLogLocator::GetInstance()
	{
		if(!m_pInstance)
			m_pInstance = new CLogLocator();

		return m_pInstance;
	}

	Util::ILogger* CLogLocator::GetLog()
	{
		return GetInstance()->Get();
	}

	void CLogLocator::ProvideLog(Util::ILogger* p_pService)
	{
		GetInstance()->Provide(p_pService);
	}

	CLogLocator::CLogLocator()
	{
		
	}

	CLogLocator::~CLogLocator()
	{

	}

	void CLogLocator::Provide(Util::ILogger* p_pService)
	{
		m_pService = p_pService;
	}

	Util::ILogger* CLogLocator::Get()
	{
		return m_pService;
	}
}