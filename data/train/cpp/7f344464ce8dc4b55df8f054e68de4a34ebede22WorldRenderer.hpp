#ifndef WORLDRENDERER_WORLDRENDERER_HPP
#define WORLDRENDERER_WORLDRENDERER_HPP

#include "ChunkRenderer.hpp"
#include "TextureRegistry.hpp"
#include "../World/World.hpp"
#include "../Renderer/Camera.hpp"

namespace Antumbra
{
	class WorldRenderer
	{
	public:
		WorldRenderer(World &world);

		void Render(const Camera &camera);
	private:
		void OnChunkLoaded(Chunk *chunk);
		void OnChunkChanged(Chunk *chunk);
		void OnChunkUnloaded(Chunk *chunk);

		World &m_world;
		Shader m_shader;
		TextureRegistry m_textureReg;
		google::dense_hash_map<Chunk *, ChunkRendererPtr> m_renderers;
	};
}

#endif