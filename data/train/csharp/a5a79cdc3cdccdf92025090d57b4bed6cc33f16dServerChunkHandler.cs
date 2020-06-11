using System;
using Google.Protobuf;
using Org.Dragonet.Cloudland.Net.Protocol;

namespace CloudLand.Networking.Handlers
{
    class ServerChunkHandler : MessageHandler
    {
        public void handle(CloudLandClient client, IMessage messageReceived)
        {
            ServerChunkMessage chunk = (ServerChunkMessage)messageReceived;
            //UnityEngine.Debug.Log("Received chunk: (" + chunk.X + "," + chunk.Z + "), chunk size=" + chunk.Chunk.Length);
            //UnityEngine.Debug.Log("Processing chunk " + string.Format("({0}, {1}, {2})", chunk.X, chunk.Y, chunk.Z));
            byte[] ids = new byte[8192];
            Buffer.BlockCopy(chunk.Chunk.ToByteArray(), 0, ids, 0, 8192);

            client.getClientComponent().chunkManager.chunkQueue.QueueCreation(
                chunk.X, chunk.Y, chunk.Z,
                ids);
        }
    }
}
