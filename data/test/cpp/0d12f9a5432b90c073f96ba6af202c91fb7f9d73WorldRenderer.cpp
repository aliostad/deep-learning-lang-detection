#include <glm/gtc/matrix_transform.hpp>
#include "WorldRenderer.hpp"

namespace Antumbra
{
	WorldRenderer::WorldRenderer(World &world) : m_world(world), m_shader("shaders/chunk.vert", "shaders/chunk.frag")
	{
		m_renderers.set_empty_key(nullptr);

		m_world.SetOnChunkLoaded([&](Chunk *c){ OnChunkLoaded(c); });
		m_world.SetOnChunkChanged([&](Chunk *c){ OnChunkChanged(c); });
		m_world.SetOnChunkUnloaded([&](Chunk *c){ OnChunkUnloaded(c); });

		BlockRegistry &blockReg = m_world.GetBlockRegistry();

		for(auto it = blockReg.begin(); it != blockReg.end(); ++it)
		{
			it->second->RegisterTextures(m_textureReg);
		}

		m_textureReg.BuildTexture();
	}

	void WorldRenderer::Render(const Camera &camera)
	{
		auto vp = camera.GetProjMatrix() * camera.GetViewMatrix();

		m_shader.Bind();
		m_textureReg.Bind(0);

		for(auto it = m_renderers.begin(); it != m_renderers.end(); ++it)
		{
			int chunkX, chunkZ;
			it->first->GetLocation(chunkX, chunkZ);

			m_shader.SetUniform("uniTex", 0);
			m_shader.SetUniform("uniMvp", vp * glm::translate(glm::mat4(), glm::vec3(chunkX * Chunk::Width, 0, chunkZ * Chunk::Depth)));

			it->second->Render();
		}
	}

	void WorldRenderer::OnChunkLoaded(Chunk *chunk)
	{
		m_renderers[chunk] = ChunkRendererPtr(new ChunkRenderer(m_world, m_shader));
		OnChunkChanged(chunk);
	}

	void WorldRenderer::OnChunkChanged(Chunk *chunk)
	{
		int chunkX, chunkZ;
		chunk->GetLocation(chunkX, chunkZ);
		ChunkCache cache(m_world, chunkX - 1, chunkZ - 1, chunkX + 1, chunkZ + 1);
		m_renderers.find(chunk)->second->Rebuild(cache, chunkX, chunkZ);
	}

	void WorldRenderer::OnChunkUnloaded(Chunk *chunk)
	{
		m_renderers.erase(m_renderers.find(chunk));
	}
}