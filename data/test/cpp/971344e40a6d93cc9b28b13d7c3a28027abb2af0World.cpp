#include "World.h"







void World::Init(IDirect3DDevice9* device)
{
	m_pDevice = device;

	

	AddChunk(2, 0, 0);
	

	
	
	
}
void World::Update(float dt)
{
	//for (Chunk c : chunk)
	//{
	//	c.Update(dt);
	//}
}
void World::Render()
{
	if (!chunk.empty())
	{
		for (int x = 0; x < chunk.size(); x++)
		{
			chunk[x].Render();
		}
	}

	





}
void World::Release()
{
	
	for (int x = 0; x < chunk.size() - 1; x++)
	{
		chunk[x].Release();
	}


	d3d::Delete(this);
}
void World::AddChunk(float x, float y, float z)
{
	chunk.push_back(Chunk(x * 10, y * 10, z * 10));
	chunk[chunk.size() - 1].Init(m_pDevice);
	chunk[0].Init(m_pDevice);
}