#include "StdAfx.h"

#include "grafx.h"
#include "GrModelXp.h"



CGrModelX::CGrModelX()
{
    mModel = new CGrModelXp();
}

CGrModelX::~CGrModelX()
{
    delete mModel;
}


void CGrModelX::Clear() {mModel->Clear();}
bool CGrModelX::LoadFile(const wchar_t *filename) {return mModel->LoadFile(filename);}

void CGrModelX::SetTransform(const CGrTransform &t) {mModel->SetTransform(t);}
void CGrModelX::Draw() {mModel->Draw();}
void CGrModelX::Draw(IRenderer *renderer) {mModel->Draw(renderer);}

bool CGrModelX::IntersectionTest(const CGrSphere &sphere)
{return mModel->IntersectionTest(sphere);}
void CGrModelX::ComputeBonesAbsolute() {mModel->ComputeBonesAbsolute();}

const wchar_t *CGrModelX::GetError() const {return mModel->GetError();}
CGrModelX::IBone *CGrModelX::GetBone(const wchar_t *name) {return mModel->GetBone(name);}


CGrModelX::IEffect::IEffect() {}
CGrModelX::IEffect::~IEffect() {}

CGrModelX::IRenderer::IRenderer() {}
CGrModelX::IRenderer::~IRenderer() {}

void CGrModelX::IRenderer::NewMesh(const wchar_t *name) {}


CGrModelX::IBone::IBone() {}
CGrModelX::IBone::~IBone() {}

CGrVector CGrModelX::GetCameraPosition(void)
{
    mModel->ComputeBonesAbsolute();
    const CGrModelX::IBone *cameraPosition = mModel->GetBone(L"Camera.Position");
    if(cameraPosition != NULL)
    {
        CGrVector tran = cameraPosition->GetAbsoluteTransform().GetTranslation();
        tran.W(1);
        return tran;
    }

    return CGrVector(0, 0, 0, 0);
}

CGrVector CGrModelX::GetCameraTarget(void)
{
    mModel->ComputeBonesAbsolute();
    const CGrModelX::IBone *cameraTarget = mModel->GetBone(L"Camera.Target");
    if(cameraTarget != NULL)
    {
        CGrVector tran = cameraTarget->GetAbsoluteTransform().GetTranslation();
        tran.W(1);
        return tran;
    }

    return CGrVector(0, 0, 0, 0);
}

