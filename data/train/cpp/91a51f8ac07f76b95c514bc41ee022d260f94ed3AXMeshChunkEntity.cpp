/* --------------------------------------------------------------
	File:			AXMeshChunkEntity.cpp
	Description:	See AXMeshChunkEntity.h

	Date:			January 5, 2006
	Author:			James Long
-------------------------------------------------------------- */

#include "AXCore.h"
#include "AXGraphics.h"
#include "AXMeshChunkEntity.h"

AXMeshChunkEntity::AXMeshChunkEntity() : _MeshChunkInstance(NULL), _Shader(NULL), _ParentMeshEntity(NULL) {
}
AXMeshChunkEntity::~AXMeshChunkEntity() {
}

AXResult AXMeshChunkEntity::AssignEffect(unsigned int ID) {
	_EffectID = ID;
	_Shader = AXBaseSystem::GetResourceMgr()->GetShader(ID);

	if(!_Shader)
		return AXFAILURE;

	return AXSUCCESS;
}

void AXMeshChunkEntity::SelectShader() {
	if(_Shader) _Shader->Enter();
}

void AXMeshChunkEntity::PrepareShader() {
	if(_Shader) {
		_Shader->FillCache(_MeshChunkInstance);
		_Shader->SetParameters(this);
		_MeshChunkInstance->SetDataSources();
	}
}

void AXMeshChunkEntity::ReleaseShader() {
	if(_Shader) {
		_Shader->Exit();
		//_Shader->ResetRenderStates();
	}
}

void AXMeshChunkEntity::Render() {
	if(_Shader) _MeshChunkInstance->Draw();
}

void AXMeshChunkEntity::_LinkMeshChunk(AXMeshChunk *Chunk) {
	_MeshChunkInstance = Chunk;
}
