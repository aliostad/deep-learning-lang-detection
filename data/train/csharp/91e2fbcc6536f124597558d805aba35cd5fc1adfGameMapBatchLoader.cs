using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Nixin
{
    public class GameMapBatchLoader : ResourceBatchLoader
    {


        // Public:


        public GameMapBatchLoader( ResourceSystem resourceSystem, MapChunk mapChunk,
            GameModeChunk gameModeChunk ) 
            : base( resourceSystem, true, GetEntriesToLoad( resourceSystem, mapChunk, gameModeChunk ) )
        {
            this.mapChunk                  = mapChunk;
            this.gameModeChunk             = gameModeChunk;
            this.sceneAssetBundle          = resourceSystem.GetSceneAssetBundle( mapChunk.SceneBundleName.Name );
        }


        public MapChunk MapChunk
        {
            get
            {
                return mapChunk;
            }
        }


        public GameModeChunk GameModeChunk
        {
            get
            {
                return gameModeChunk;
            }
        }


        public AssetBundle SceneAssetBundle
        {
            get
            {
                return sceneAssetBundle;
            }
        }


        // Private:


        private MapChunk            mapChunk              = null;
        private GameModeChunk       gameModeChunk         = null;
        private AssetBundle         sceneAssetBundle      = null;


        private static NixinAssetBundleEntry[] GetEntriesToLoad( ResourceSystem resourceSystem,
            MapChunk mapChunk, GameModeChunk gameModeChunk )
        {
            var ret = mapChunk.GetChunkEntries();
            ret.AddRange( gameModeChunk.GetChunkEntries() );

            // Add game mode chunk weak references.
            if( !gameModeChunk.HudPrefab.IsNull )
            {
                ret.Add( gameModeChunk.HudPrefab.GetEntry( resourceSystem ) );
            }
            if( !gameModeChunk.ManagerPrefab.IsNull )
            {
                ret.Add( gameModeChunk.ManagerPrefab.GetEntry( resourceSystem ) );
            }
            if( !gameModeChunk.LocalManagerPrefab.IsNull )
            {
                ret.Add( gameModeChunk.LocalManagerPrefab.GetEntry( resourceSystem ) );
            }
            if( !gameModeChunk.StatePrefab.IsNull )
            {
                ret.Add( gameModeChunk.StatePrefab.GetEntry( resourceSystem ) );
            }
            if( !gameModeChunk.StatsPrefab.IsNull )
            {
                ret.Add( gameModeChunk.StatsPrefab.GetEntry( resourceSystem ) );
            }

            // Add extension chunk weak references.
            if( gameModeChunk.RequiresMapExtension )
            {
                var extensionChunk = mapChunk.GetExtension( gameModeChunk );
                if( extensionChunk != null && !extensionChunk.ExtensionPrefab.IsNull )
                {
                    ret.Add( extensionChunk.ExtensionPrefab.GetEntry( resourceSystem ) );
                }
            }
            return ret.ToArray();
        }
    }
}

