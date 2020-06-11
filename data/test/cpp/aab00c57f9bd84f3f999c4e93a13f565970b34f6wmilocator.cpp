#include "wmilocator.hpp"

#include <stdexcept>

WmiLocator::WmiLocator(IWbemLocator* locator, bool take) :
	ComPointer<IWbemLocator>(locator, take)
{}


bool WmiLocator::initialise()
{
	IWbemLocator* loc = 0;
    HRESULT hr = CoCreateInstance(
		CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER,
		IID_IWbemLocator, (LPVOID*)&loc);
	
	if (FAILED(hr))
	{
		qWarningFromHresult(hr, "WMI Locator creation failed");
		return false;
	}
	reset(loc);
	return true;
}

WmiService WmiLocator::connectServer(const QString& serviceNamespace) const
{
	if (!valid())
	{
		qWarning() << "Locator invalid";
		return WmiService();
	}
	
	IWbemServices* svc = 0;
	BStrScoped sns(serviceNamespace);
	HRESULT hr = get()->ConnectServer(sns, NULL, NULL, 0, NULL, 0, 0, &svc);
	if (FAILED(hr))
	{
		qWarningFromHresult(hr, "Can not connect to WMI server");
		return WmiService();
	}
	
	hr = CoSetProxyBlanket(
		svc,
		RPC_C_AUTHN_WINNT,
		RPC_C_AUTHZ_NONE,
		NULL,
		RPC_C_AUTHN_LEVEL_CALL,
		RPC_C_IMP_LEVEL_IMPERSONATE,
		NULL,
		EOAC_NONE
	);
	if (FAILED(hr))
	{
		svc->Release();
		qWarningFromHresult(hr, "Could not set WMI service security");
		return WmiService();
	}
	return WmiService(svc);
}