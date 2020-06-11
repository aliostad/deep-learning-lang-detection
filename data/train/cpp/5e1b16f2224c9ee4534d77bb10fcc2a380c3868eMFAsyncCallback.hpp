#pragma once
#include <wrl\implements.h>
#include <mfapi.h>      //IMFAsyncCallback
#include <functional>   // std::function
using namespace Microsoft::WRL;

typedef ComPtr<IMFAsyncCallback> IMFAsyncCallbackPtr;
typedef std::function<HRESULT(IMFAsyncResult*)> invoke_t;

class MFAsyncCallback : public RuntimeClass<RuntimeClassFlags<ClassicCom>, IMFAsyncCallback> {
  invoke_t invoke;

public:
  HRESULT RuntimeClassInitialize(invoke_t const& fn)   {
    invoke = fn;
    return S_OK;
  }
  static IMFAsyncCallbackPtr New(invoke_t const&fn){
    IMFAsyncCallbackPtr v;
    auto hr = MakeAndInitialize<MFAsyncCallback>(&v, fn);
    hr;
    return v;
  }

  // IMFAsyncCallback methods
  STDMETHODIMP GetParameters(DWORD*, DWORD*)
  {
    // Implementation of this method is optional.
    return E_NOTIMPL;
  }

  STDMETHODIMP Invoke(IMFAsyncResult* pAsyncResult)
  {
    return invoke(pAsyncResult);
  }
};
