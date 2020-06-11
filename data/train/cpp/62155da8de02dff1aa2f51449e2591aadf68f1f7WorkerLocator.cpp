#include "WorkerLocator.h"

namespace Service
{
	struct WorkerSort 
	{
		bool operator() (IWorker* p_pLeft, IWorker* p_pRight) 
		{ 
			return (p_pLeft->GetPriority() > p_pRight->GetPriority());
		}

	} WorkerSorter;


	CWorkerLocator* CWorkerLocator::m_pInstance = nullptr;

	CWorkerLocator::CWorkerLocator()
	{

	}

	CWorkerLocator::~CWorkerLocator()
	{
		
	}

	CWorkerLocator* CWorkerLocator::GetInstance()
	{
		if(!m_pInstance)
			m_pInstance = new CWorkerLocator();

		return m_pInstance;
	}

	IWorker* CWorkerLocator::GetWorker()
	{
		return GetInstance()->Get();	
	}

	void CWorkerLocator::ProvideWorker(IWorker* p_pWorker)
	{
		GetInstance()->Provide(p_pWorker);
	}

	bool CWorkerLocator::IsWorkDone()
	{
		return GetInstance()->IsDone();
	}

	void CWorkerLocator::Provide(IWorker* p_pService)
	{
		m_vWorkers.push_back(p_pService);
	}

	IWorker* CWorkerLocator::Get()
	{
		std::sort(m_vWorkers.begin(), m_vWorkers.end(), WorkerSorter);

		for(IWorker* pWorker : m_vWorkers)
		{
			if(!pWorker->IsBusy())
				return pWorker;
		}

		return nullptr;
	}

	bool CWorkerLocator::IsDone() const
	{
		bool bDone = true;
		for(IWorker* pWorker : m_vWorkers)
		{
			bDone &= !pWorker->IsBusy();
		}
		return bDone;
	}
}