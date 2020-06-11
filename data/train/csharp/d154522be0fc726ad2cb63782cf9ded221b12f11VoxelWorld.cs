using UnityEngine;
using System.Collections;
using C5;
using Assets.components.abstracts;

namespace Assets.components {

    [RequireComponent(typeof(VoxelGeometryDrawer))]
    public class VoxelWorld : MonoBehaviour {

        public int chunkSize;
        private SpatialHash _chunkBasket;

        void Awake() {
            this._chunkBasket = new SpatialHash(this);
        }


        public VoxelWorldChunk getChunkAt(int x, int y, int z){
            Vector3 chunkAABBOrigin = this.getGlobalAABBCoordinates(x, y, z);
            VoxelWorldChunk chunk = null ;

            if (this._chunkBasket.hasChunkAt(chunkAABBOrigin)) {
                chunk = this._chunkBasket.getChunkAt(chunkAABBOrigin);
            } else {
                GameObject chunkAnchor = new GameObject("WorldChunk");
                float semiChunkSize = ((float)this.chunkSize) / 2;
                chunkAnchor.transform.parent = this.transform;
                chunkAnchor.isStatic = true;
                chunk = chunkAnchor.AddComponent<VoxelWorldChunk>() as VoxelWorldChunk;
                chunk.size = this.chunkSize;
                chunk.originX = (int)chunkAABBOrigin.x;
                chunk.originY = (int)chunkAABBOrigin.y;
                chunk.originZ = (int)chunkAABBOrigin.z;
                chunk.transform.position = new Vector3(x, y, z);
                this._chunkBasket.addChunkAt(chunk, chunkAABBOrigin);
            }
            return chunk;
        }


        public void addVoxelAt(Voxel voxel, int x, int y, int z) {
            //estrazione del chunk corrispondente alla posizione 
            //cui si desidera aggiungere un voxel.
            Vector3 chunkAABBOffset = this.getLocalAABBCoordinates(x, y, z);
            VoxelWorldChunk chunk = this.getChunkAt(x, y, z);
            
            //quindi aggiungiamo il voxel al chunk soltanto se
            //questo non ne contiene già uno alla posizione data.
            int localX = (int)chunkAABBOffset.x;
            int localY = (int)chunkAABBOffset.y;
            int localZ = (int)chunkAABBOffset.z;
            if (!chunk.hasVoxelAt(localX, localY, localZ)) {
                chunk.addVoxelAt(voxel, localX, localY, localZ);
                //chunk.update();
            }
        }




        public void removeVoxelAt(int x, int y, int z) {
            Vector3 chunkAABBOrigin = this.getGlobalAABBCoordinates(x, y, z);
            Vector3 chunkAABBOffset = this.getLocalAABBCoordinates(x, y, z);

            //estrazione del chunk corrispondente alla posizione 
            //cui si desidera aggiungere un voxel.
            if (this._chunkBasket.hasChunkAt(chunkAABBOrigin)) {
                VoxelWorldChunk chunk = this._chunkBasket.getChunkAt(chunkAABBOrigin);
                chunk.removeVoxelAt((int)chunkAABBOffset.x, (int)chunkAABBOffset.y, (int)chunkAABBOffset.z);

                //se il chunk non contiene più blocchi allora lo rimuoviamo
                //altrimenti lo ridisegnamo
                if (chunk.count == 0) {
                    chunk.transform.parent = null;
                    this._chunkBasket.removeChunkAt(chunkAABBOrigin);
                } else {
                    chunk.update();
                }
            }
        }




        public bool hasVoxelAt(int x, int y, int z) {
            bool retval = false;
            Vector3 chunkAABBOrigin = this.getGlobalAABBCoordinates(x, y, z);
            Vector3 chunkAABBOffset = this.getLocalAABBCoordinates(x, y, z);

            //estrazione del chunk corrispondente alla posizione 
            //cui si desidera aggiungere un voxel.
            if (this._chunkBasket.hasChunkAt(chunkAABBOrigin)) {
                VoxelWorldChunk chunk = this._chunkBasket.getChunkAt(chunkAABBOrigin);
                retval = chunk.hasVoxelAt((int)chunkAABBOffset.x, (int)chunkAABBOffset.y, (int)chunkAABBOffset.z);
            }

            return retval;
        }




        public Voxel getVoxelAt(int x, int y, int z) {
            
            Voxel retval = null;

            Vector3 chunkAABBOrigin = this.getGlobalAABBCoordinates(x, y, z);
            Vector3 chunkAABBOffset = this.getLocalAABBCoordinates(x, y, z);

            //estrazione del chunk corrispondente alla posizione 
            //cui si desidera aggiungere un voxel.
            if (this._chunkBasket.hasChunkAt(chunkAABBOrigin))
            {
                VoxelWorldChunk chunk = this._chunkBasket.getChunkAt(chunkAABBOrigin);
                retval = chunk.getVoxelAt((int)chunkAABBOffset.x, (int)chunkAABBOffset.y, (int)chunkAABBOffset.z);
            }

            return retval;
        }



        private Vector3 getGlobalAABBCoordinates(int x, int y, int z) {
            int newX, newY, newZ;

            if (x >= 0) {
                newX = (x / this.chunkSize) * this.chunkSize;
            } else {
                newX = (this.chunkSize * (x / this.chunkSize)) - this.chunkSize;
            }

            if (y >= 0) {
                newY = (y / this.chunkSize) * this.chunkSize;
            } else {
                newY = (this.chunkSize * (y / this.chunkSize)) - this.chunkSize;
            }

            if (z >= 0) {
                newZ = (z / this.chunkSize) * this.chunkSize;
            } else {
                newZ = (this.chunkSize * (z / this.chunkSize)) - this.chunkSize;
            }

            return new Vector3(newX, newY, newZ);
        }



        private Vector3 getLocalAABBCoordinates(int x, int y, int z) {
            int newX, newY, newZ;

            if (x >= 0) {
                newX = x % this.chunkSize;
            } else {
                newX = this.chunkSize + (x % this.chunkSize);
            }

            if (y >= 0) {
                newY = y % this.chunkSize;
            } else {
                newY = this.chunkSize + (y % this.chunkSize);
            }

            if (z >= 0) {
                newZ = z % this.chunkSize;
            } else {
                newZ = this.chunkSize + (z % this.chunkSize);
            }

            return new Vector3(newX, newY, newZ);
        }



        private class SpatialHash {
            private HashDictionary<Vector3, VoxelWorldChunk> _map;

            internal SpatialHash(VoxelWorld world) {
                this._map = new HashDictionary<Vector3, VoxelWorldChunk>();
            }

            internal void addChunkAt(VoxelWorldChunk chunk, Vector3 position) {
                this._map.Add(position, chunk);
            }

            internal bool hasChunkAt(Vector3 position) {
                return this._map.Contains(position);
            }

            internal VoxelWorldChunk getChunkAt(Vector3 position) {
                return this._map[position];
            }

            internal void removeChunkAt(Vector3 position) {
                this._map.Remove(position);
            }
        }
    }

}