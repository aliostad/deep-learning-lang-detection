// ============================================================================
//
// Apollo
//
// ============================================================================

#if !defined(SampleModule_H_INCLUDED)
#define SampleModule_H_INCLUDED

#include "ApModule.h"
#include "ApContainer.h"
#include "MsgUnitTest.h"
#include "SrpcGateHelper.h"
#include "Sample.h"

typedef ApHandlePointerTree<Sample*> SampleList;
typedef ApHandlePointerTreeNode<Sample*> SampleListNode;
typedef ApHandlePointerTreeIterator<Sample*> SampleListIterator;

class SampleModule
{
public:
  SampleModule()
    :nTheAnswer_(42)
    {}

  int Init();
  void Exit();

  void On_Sample_Create(Msg_Sample_Create* pMsg);
  void On_Sample_Destroy(Msg_Sample_Destroy* pMsg);
  void On_Sample_Get(Msg_Sample_Get* pMsg);

#if defined(AP_TEST)
  void On_UnitTest_Begin(Msg_UnitTest_Begin* pMsg);
  void On_UnitTest_Execute(Msg_UnitTest_Execute* pMsg);
  void On_UnitTest_End(Msg_UnitTest_End* pMsg);
  friend class SampleModuleTester;
#endif

protected:
  Sample* NewSample(const ApHandle& hSample);
  void DeleteSample(const ApHandle& hSample);
  Sample* FindSample(const ApHandle& hSample); // return 0 if !found
  Sample* GetSample(const ApHandle& hSample) throw (ApException); // ApException if !found

protected:
  int nTheAnswer_;
  SampleList samples_;

  Apollo::SrpcGateHandlerRegistry srpcGateRegistry_;
  AP_MSG_REGISTRY_DECLARE;
};

typedef ApModuleSingleton<SampleModule> SampleModuleInstance;

#endif // SampleModule_H_INCLUDED
