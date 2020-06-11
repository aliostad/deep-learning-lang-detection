#include <diy/tds/tds.hpp>

namespace diy
{
	namespace tds
	{
		TdsMatrix::TdsMatrix(void)
		{
			;
		}

		TdsMatrix::~TdsMatrix(void)
		{
			;
		}

		bool TdsMatrix::LoadFromChunkAndFStream(class TdsChunk& chunk, std::ifstream& in)
		{
			if (chunk.Type != TDS_MESH_MATRIX)
			{
				return false;
			}

			X.LoadFromChunkAndFStream(chunk, in);
			Y.LoadFromChunkAndFStream(chunk, in);
			Z.LoadFromChunkAndFStream(chunk, in);
			Origin.LoadFromChunkAndFStream(chunk, in);

			if (chunk.OnString)
			{
				char buffer[32];
				sprintf(buffer, "%.1f, %.1f, %.1f", X.X, X.Y, X.Z);
				chunk.OnString(buffer, chunk.User);
				sprintf(buffer, "%.1f, %.1f, %.1f", Y.X, Y.Y, Y.Z);
				chunk.OnString(buffer, chunk.User);
				sprintf(buffer, "%.1f, %.1f, %.1f", Z.X, Z.Y, Z.Z);
				chunk.OnString(buffer, chunk.User);
				sprintf(buffer, "%.1f, %.1f, %.1f", Origin.X, Origin.Y, Origin.Z);
				chunk.OnString(buffer, chunk.User);
			}

			return true;
		}

		TdsMatrix::operator glm::mat4(void)
		{
			return glm::mat4
				(
				glm::vec4(glm::vec3(X), 0.0f),
				glm::vec4(glm::vec3(Y), 0.0f),
				glm::vec4(glm::vec3(Z), 0.0f),
				glm::vec4(glm::vec3(Origin), 1.0f)
				);
		}
	}
}
