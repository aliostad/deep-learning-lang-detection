using UnityEngine;
using System;
using System.Collections.Generic;
using Zenject;

namespace MistRidge
{
    public class ChunkFacadeFactory : FacadeFactory<ChunkRequest, ChunkFacade>
    {
        private readonly IChunkFeaturePickingStrategy chunkFeaturePickingStrategy;

        public ChunkFacadeFactory(
                IChunkFeaturePickingStrategy chunkFeaturePickingStrategy)
        {
            this.chunkFeaturePickingStrategy = chunkFeaturePickingStrategy;
        }

        public override ChunkFacade Create(ChunkRequest chunkRequest)
        {
            DiContainer subContainer = CreateSubContainer(chunkRequest);

            ChunkFeature chunkFeature = chunkFeaturePickingStrategy.Pick(chunkRequest);
            subContainer.Bind<ChunkFeature>().ToSingleInstance(chunkFeature);

            GameObject prefab = chunkFeature.ChunkFeatureView.gameObject;
            subContainer.Bind<ChunkFeatureView>().ToSinglePrefab(prefab);

            ChunkFacade chunkFacade = subContainer.Resolve<ChunkFacade>();
            chunkFacade.Initialize();

            return chunkFacade;
        }
    }
}
