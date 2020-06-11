#include "MyClassModelRenderer.h"
namespace MY_NS_MODEL
{
	MyClassModelRenderer::MyClassModelRenderer(MyClassModel * _pModel)
	{
		pModel=_pModel;
		if (pModel) pModel->RegMessReceiver(this);
	}
	void MyClassModelRenderer::AttachModel(MyClassModel * _pModel)
	{
		if (pModel!=_pModel)
		{
			if (pModel) pModel->UnRegMessReceiver(this);
			pModel=_pModel;
			if (pModel) pModel->RegMessReceiver(this);
		}
	}
	MyClassModel * MyClassModelRenderer::GetPointAttachedModel()
	{
		return pModel;
	}
	const MyClassModel * MyClassModelRenderer::GetPointAttachedModel()const
	{
		return pModel;
	}
	void MyClassModelRenderer::MessageReseive(MyClassMessage _message, MyClassMessageSender * fromWho)
	{
		if (_message.message==die && fromWho==pModel) pModel=0;
	}
	MyClassModelRenderer::~MyClassModelRenderer(void)
	{
		if (pModel) pModel->UnRegMessReceiver(this);
	}

}
