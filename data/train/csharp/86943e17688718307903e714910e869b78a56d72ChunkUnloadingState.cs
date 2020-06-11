// -----------------------------------------------------------------
// File:    ChunkUnloadingState.cs
// Author:  mouguangyi
// Date:    2016.12.13
// Description:
//      
// -----------------------------------------------------------------
using GameBox.Framework;

namespace GameBox.Service.LevelSystem
{
    sealed class ChunkUnloadingState : ChunkState
    {
        public ChunkUnloadingState(SceneChunk.States stateId) : base(stateId)
        { }

        public override void Execute(StateMachine stateMachine, float delta)
        {
            var chunk = stateMachine.Model as SceneChunk;
            chunk._LifeTime -= delta;
            if (chunk._LifeTime <= 0) {
                chunk._LifeTime = 0;
                for (var i = 0; i < chunk._Objects.Count; ++i) {
                    chunk._Objects[i].Unload();
                }
                chunk._ChangeState(SceneChunk.States.UNLOADED);
            }
        }
    }
}