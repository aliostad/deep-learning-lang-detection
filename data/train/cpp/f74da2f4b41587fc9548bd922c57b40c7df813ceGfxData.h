#pragma once
namespace Gfx {
	struct GraphicState {

	};
	template<typename DrawOpApi>
	struct DrawOperationInterface {
		GraphicState<DrawOpApi::graphics_state_api_type> gfx_state;
		GfxGeometryBuffers<DrawOpApi::geom_api_type> geom;
	};
	template<typename VertexBufferApi, typename IndexBufferApi>
	struct CachedGeometry {
		VertexBufferApi position;
		VertexBufferApi normal;
		VertexBufferApi uv;
		IndexBufferApi indices;
	};
	template<typename DrawTargetApi>
	struct DrawTargetInterface {
		DrawTargetInterface(DrawTargetApi api) : target(api) { }
		DrawTargetApi::draw_target_type target;
	};
	template<typename TextureApi>
	struct TextureInterface {
		TextureInterface(const TextureApi& api) : api_(api) {

		}
		void clear(vec3 value) {
			api_.clear(value);
		}
		void clear(float value) {
			api_.clear(value);
		}
		TextureApi api_;
	};

	template<typename ShaderApi>
	class ShaderProgramInterface {
	public:
		ShaderProgramInterface(ShaderApi api) : api_(api) { }
		ShaderApi api_;
	};
	template<typename CachedGeomType, typename TextureApi>
	struct CachedMeshInterface {
		CachedGeomType geom;
		unsigned int num_indices;
	};
}