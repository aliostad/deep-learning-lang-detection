using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MinecraftClone.Domain.Terrain;

namespace MinecraftClone.Domain.Renderer {
	class TerrainRenderer {
		private World world;

		private GameObject chunkPrefab;

		private GameObject target;

		public TerrainRenderer(World world, GameObject target) {
			this.world = world;
			this.target = target;
			this.chunkPrefab = Resources.Load("Prefabs/Chunk") as GameObject;
		}

		public void Init() {
			Unload ();
		}

		public void Unload() {
			foreach (var chunk in world.Chunks.Values) {
				foreach (var obj in chunk.GameObjects.Values) {
					GameObject.Destroy (obj);
				}
				chunk.GameObjects.Clear ();
			}
		}

		public bool IsDrawed(Vector3 position) {
			return IsDrawed (ChunkAddress.FromPosition (position));
		}

		public bool IsDrawed(ChunkAddress address) {
			return world.IsGenerated (address) && world [address].GameObjects.Count > 0;
		}

		public void Redraw(Vector3 position) {
			Redraw (ChunkAddress.FromPosition (position));
		}

		public void Redraw(ChunkAddress address) {
			var chunk = world [address];
			SetMesh (chunk);
		}

		public void Draw(Vector3 position) {
			Draw (ChunkAddress.FromPosition (position));
		}

		public void Draw(ChunkAddress address) {
			var chunk = world [address];

			if (!IsDrawed (address)) {
				chunk.GameObjects ["Chunk"] = CreateGameObject (chunk, chunkPrefab);

				SetMesh (chunk);

				chunk.GameObjects ["Chunk"].SetActive (true);
			}
		}

		private void SetMesh (Chunk chunk) {
			var factory = new ChunkMeshFactory (chunk);
			var mesh = factory.Create ();

			chunk.GameObjects ["Chunk"].GetComponent<MeshCollider> ().sharedMesh = mesh.collider;
			chunk.GameObjects ["Chunk"].GetComponent<MeshFilter> ().mesh = mesh.renderer;
		}

		private GameObject CreateGameObject (Chunk chunk, GameObject prefab) {
			return GameObject.Instantiate(
				prefab,
				chunk.Address.ToPosition(),
				Quaternion.identity,
				target.transform
			);
		}
	}
}