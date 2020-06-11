// -----------------------------------------------------------------
// File:    ChunkUnloadedState.cs
// Author:  mouguangyi
// Date:    2016.12.13
// Description:
//      
// -----------------------------------------------------------------
using GameBox.Framework;

namespace GameBox.Service.LevelSystem
{
    sealed class ChunkUnloadedState : ChunkState
    {
        public ChunkUnloadedState(SceneChunk.States stateId) : base(stateId)
        { }

        public override void Enter(StateMachine stateMachine)
        {
            var chunk = stateMachine.Model as SceneChunk;
            chunk._NotifyDestroy();
        }
    }
}