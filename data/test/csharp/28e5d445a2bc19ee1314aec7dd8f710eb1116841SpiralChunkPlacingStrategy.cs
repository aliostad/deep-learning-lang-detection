using UnityEngine;
using System;
using System.Collections.Generic;
using Zenject;

namespace MistRidge
{
    public class SpiralChunkPlacingStrategy : IChunkPlacingStrategy
    {
        private readonly Settings settings;
        private readonly ChunkReference chunkReference;

        private ChunkView previousChunkView;

        public SpiralChunkPlacingStrategy(
                Settings settings,
                ChunkReference chunkReference)
        {
            this.settings = settings;
            this.chunkReference = chunkReference;
        }

        public void Place(ChunkView chunkView, ChunkRequest chunkRequest, ChunkFeature chunkFeature, ChunkFeatureView chunkFeatureView)
        {
            if (chunkRequest.chunkNum == 0)
            {
                chunkView.Rotation *= Quaternion.AngleAxis(
                    120,
                    chunkView.Up
                );
                chunkView.Position = Vector3.zero + Altitude(chunkRequest, chunkFeature, chunkFeatureView);
                return;
            }

            chunkView.Rotation *= BirdseyeRotation(chunkView, chunkRequest);
            chunkView.Position = BirdseyePosition(chunkView, chunkRequest, chunkFeature, chunkFeatureView);

            previousChunkView = chunkView;
        }

        private Quaternion BirdseyeRotation(ChunkView chunkView, ChunkRequest chunkRequest)
        {
            int side = ChunkMath.Side(chunkRequest);
            int depthStartChunkNum = ChunkMath.DepthStartChunkNum(chunkRequest);
            int depthEndChunkNum = ChunkMath.DepthEndChunkNum(chunkRequest);

            if (chunkRequest.chunkNum == depthStartChunkNum || chunkRequest.chunkNum == depthEndChunkNum)
            {
                side = 5;
            }

            side = (side + 4) % 6;

            return Quaternion.AngleAxis(
                side * 60,
                chunkView.Up
            );
        }

        private Vector3 BirdseyePosition(ChunkView chunkView, ChunkRequest chunkRequest, ChunkFeature chunkFeature, ChunkFeatureView chunkFeatureView)
        {
            int depth = ChunkMath.Depth(chunkRequest);
            int side = ChunkMath.Side(chunkRequest);
            int depthStartChunkNum = ChunkMath.DepthStartChunkNum(chunkRequest);
            int sideStartChunkNum = ChunkMath.SideStartChunkNum(chunkRequest);
            int sideChunkNum = ChunkMath.SideChunkNum(chunkRequest);

            switch (side)
            {
                case 0:
                    return Position(chunkRequest, chunkReference.Northeast, chunkReference.Northwest, sideChunkNum, depth, chunkFeature, chunkFeatureView);
                case 1:
                    return Position(chunkRequest, chunkReference.East, chunkReference.Northeast, sideChunkNum, depth, chunkFeature, chunkFeatureView);
                case 2:
                    return Position(chunkRequest, chunkReference.Southeast, chunkReference.East, sideChunkNum, depth, chunkFeature, chunkFeatureView);
                case 3:
                    return Position(chunkRequest, chunkReference.Southwest, chunkReference.Southeast, sideChunkNum, depth, chunkFeature, chunkFeatureView);
                case 4:
                    return Position(chunkRequest, chunkReference.West, chunkReference.Southwest, sideChunkNum, depth, chunkFeature, chunkFeatureView);
                case 5:
                    return Position(chunkRequest, chunkReference.Northwest, chunkReference.West, sideChunkNum, depth, chunkFeature, chunkFeatureView);
            }

            Debug.LogError("Failed to compute spiral chunk position");
            return Vector3.zero;
        }

        private Vector3 Position(ChunkRequest chunkRequest, Vector3 sideDirection, Vector3 depthDirection, int sideChunkNum, int depth, ChunkFeature chunkFeature, ChunkFeatureView chunkFeatureView)
        {
            return ((sideChunkNum + 1) * sideDirection) + ((depth - sideChunkNum - 1) * depthDirection) + Altitude(chunkRequest, chunkFeature, chunkFeatureView);
        }

        private Vector3 Altitude(ChunkRequest chunkRequest, ChunkFeature chunkFeature, ChunkFeatureView chunkFeatureView)
        {
            if (previousChunkView == null)
            {
                return settings.mountainOffset * Vector3.up;
            }

            float previousAltitude = previousChunkView.Position.y + previousChunkView.ChunkFeatureView.ExitAltitude;

            if (chunkFeature.MatchChainHeight)
            {
                return (previousAltitude - chunkFeatureView.EntryAltitude) * Vector3.up;
            }

            float variability = UnityEngine.Random.value * settings.altitudeRange;

            return (variability + previousAltitude - chunkFeatureView.EntryAltitude) * Vector3.up;
        }

        [Serializable]
        public class Settings
        {
            public float mountainOffset;
            public float altitudeRange;
        }
    }
}
