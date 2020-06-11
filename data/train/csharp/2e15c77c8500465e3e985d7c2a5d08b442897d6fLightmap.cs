public class Lightmap {
	
	private Grid<SunLightChunk> sunChunks = new Grid<SunLightChunk>();
	private Grid<LightChunk> chunks = new Grid<LightChunk>();
	
	public void SetSunHeight(int height, int x, int z) {
		Vector3i chunkPos = Chunk.ToChunkPosition(x, 0, z);
		Vector3i localPos = Chunk.ToLocalPosition(x, 0, z);
		
		SunLightChunk chunk = GetSunChunkInstance(chunkPos.x, chunkPos.z);
		chunk.SetSunHeight( height, localPos.x, localPos.z );
	}
	
	public int GetSunHeight(int x, int z) {
		Vector3i chunkPos = Chunk.ToChunkPosition(x, 0, z);
		Vector3i localPos = Chunk.ToLocalPosition(x, 0, z);
		SunLightChunk chunk = GetSunChunk(chunkPos.x, chunkPos.z);
		if(chunk != null) return chunk.GetSunHeight(localPos.x, localPos.z);
		return Map.maxChunkY;
	}
	
	public bool IsSunLight(int x, int y, int z) {
		Vector3i chunkPos = Chunk.ToChunkPosition(x, y, z);
		Vector3i localPos = Chunk.ToLocalPosition(x, y, z);
		SunLightChunk chunk = GetSunChunk(chunkPos.x, chunkPos.z);
		if(chunk != null) return chunk.IsLight(localPos.x, y, localPos.z);
		return false;
	}
	
	
	
	public bool SetMaxLight(byte light, int x, int y, int z) {
		Vector3i chunkPos = Chunk.ToChunkPosition(x, y, z);
		Vector3i localPos = Chunk.ToLocalPosition(x, y, z);
		
		SunLightChunk sunChunk = GetSunChunk(chunkPos.x, chunkPos.z);
		if(sunChunk != null && sunChunk.IsLight(localPos.x, y, localPos.z)) {
			return false;
		}
		
		LightChunk lightChunk = GetLightChunkInstance(chunkPos);
		return lightChunk.SetMaxLight(light, localPos);
	}
	
	
	public void SetLight(byte light, Vector3i pos) {
		SetLight(light, pos.x, pos.y, pos.z);
	}
	public void SetLight(byte light, int x, int y, int z) {
		Vector3i chunkPos = Chunk.ToChunkPosition(x, y, z);
		Vector3i localPos = Chunk.ToLocalPosition(x, y, z);
		SetLight(light, chunkPos, localPos);
	}
	public void SetLight(byte light, Vector3i chunkPos, Vector3i localPos) {
		LightChunk lightChunk = GetLightChunk(chunkPos);
		if(lightChunk == null) {
			if(light == LightComputer.MIN_LIGHT) return;
			lightChunk = GetLightChunkInstance(chunkPos);
		}
		lightChunk.SetLight(light, localPos);
	}
	
	public byte GetLight(Vector3i pos) {
		return GetLight(pos.x, pos.y, pos.z);
	}
	public byte GetLight(int x, int y, int z) {
		Vector3i chunkPos = Chunk.ToChunkPosition(x, y, z);
		Vector3i localPos = Chunk.ToLocalPosition(x, y, z);
		return GetLight(chunkPos, localPos);
	}
	public byte GetLight(Vector3i chunkPos, Vector3i localPos) {
		SunLightChunk sunChunk = GetSunChunk(chunkPos.x, chunkPos.z);
		int worldY = (chunkPos.y << Chunk.SIZE_Y_BITS) + localPos.y;
		if(sunChunk != null && sunChunk.IsLight(localPos.x, worldY, localPos.z)) return LightComputer.MAX_LIGHT;
		
		LightChunk lightChunk = GetLightChunk(chunkPos);
		if(lightChunk != null) return lightChunk.GetLight(localPos);
		return LightComputer.MIN_LIGHT;
	}
	
	
	
	private SunLightChunk GetSunChunkInstance(int x, int z) {
		SunLightChunk chunk = GetSunChunk(x, z);
		if(chunk == null) {
			chunk = new SunLightChunk();
			sunChunks.AddOrReplace(chunk, x, 0, z);
		}
		return chunk;
	}
	private SunLightChunk GetSunChunk(int x, int z) {
		return sunChunks.SafeGet(x, 0, z);
	}
	
	private LightChunk GetLightChunkInstance(Vector3i pos) {
		LightChunk chunk = GetLightChunk(pos);
		if( chunk == null ) {
			chunk = new LightChunk();
			chunks.AddOrReplace(chunk, pos);
		}
		return chunk;
	}
	private LightChunk GetLightChunk(Vector3i pos) {
		return chunks.SafeGet(pos);
	}
	
}

class SunLightChunk {
	
	private short[,] map = new short[Chunk.SIZE_Z, Chunk.SIZE_X];
	
	public SunLightChunk() {
		for(int z=0; z<Chunk.SIZE_Z; z++) {
			for(int x=0; x<Chunk.SIZE_X; x++) {
				map[z, x] = short.MaxValue;
			}
		}
	}
	
	public void SetSunHeight(int height, int x, int z) {
		map[z, x] = (short)height;
	}
	public int GetSunHeight(int x, int z) {
		return map[z, x];
	}
	
	public bool IsLight(int localX, int worldY, int localZ) {
		return GetSunHeight(localX, localZ) <= worldY;
	}
	
}

class LightChunk {
	
	private byte[,,] lights = new byte[Chunk.SIZE_Z, Chunk.SIZE_Y, Chunk.SIZE_X];
	
	public LightChunk() {
		for(int z=0; z<Chunk.SIZE_Z; z++) {
			for(int y=0; y<Chunk.SIZE_Y; y++) {
				for(int x=0; x<Chunk.SIZE_X; x++) {
					lights[z, y, x] = LightComputer.MIN_LIGHT;
				}
			}
		}
	}
	
	public bool SetMaxLight(byte light, Vector3i pos) {
		if(GetLight(pos) < light) {
			SetLight(light, pos);
			return true;
		}
		return false;
	}
	
	public void SetLight(byte light, Vector3i pos) {
		SetLight(light, pos.x, pos.y, pos.z);
	}
	private void SetLight(byte light, int x, int y, int z) {
		lights[z, y, x] = light;
	}
	
	public byte GetLight(Vector3i pos) {
		return GetLight(pos.x, pos.y, pos.z);
	}
	private byte GetLight(int x, int y, int z) {
		return lights[z, y, x];
	}
	
}