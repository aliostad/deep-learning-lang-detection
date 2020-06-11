using AnnieReplays.Region;
using Newtonsoft.Json.Linq;

namespace AnnieReplays
{
    class ReplayRecorder
    {
        public string GameId { get; private set; }
        public string EncKey { get; private set; }
        private Getter Getter;
        private ReplayWriter writer;

        public delegate void FinishedRecordingHandler(string gameId);
        public event FinishedRecordingHandler FinishedRecording;

        public ReplayRecorder(IRegion region, string gameId,string encKey)
        {
            GameId = gameId;
            EncKey = encKey;
            writer = new ReplayWriter(region,gameId);
            Getter = new Getter(region, gameId);
        }

        public void StartRecord()
        {
            writer.WriteVersion(Getter.GetVersion());

            #region Get Metadata
            var metadata = JObject.Parse(Getter.GetGameMetadata());

            while (true)
            {
                var chunk = JObject.Parse(Getter.GetLastChunkInfo());
                if ((int)chunk["chunkId"] > (int)metadata["endStartupChunkId"])
                {
                    break;
                }
                else
                {
                    Util.Delay((int)chunk["nextAvailableChunk"]);
                    continue;
                }
            }

            //Get metadata again
            var newMetadata = JObject.Parse(Getter.GetGameMetadata());

            for (int i = 1; i <= (int)newMetadata["endStartupChunkId"]; i++)
            {
                while (true)
                {
                    var chunkInfo = JObject.Parse(Getter.GetLastChunkInfo());
                    if (i > (int)chunkInfo["chunkId"])
                    {
                        Util.Delay((int)chunkInfo["nextAvailableChunk"]);
                        continue;
                    }
                    var chunkFrame = Getter.GetChunkFrame(i.ToString());
                    writer.WriteChunk(i.ToString(), chunkFrame);
                    break;
                }
            }
            #endregion

            #region GetFrames
            int firstChunk = 0;
            int firstKeyFrame = 0;
            int lastChunk = 0;
            int lastKeyFrame = 0;

            while (true)
            {
                var chunkInfo = JObject.Parse(Getter.GetLastChunkInfo());

                if (firstChunk == 0)
                {
                    if ((int)chunkInfo["chunkId"] > (int)chunkInfo["startGameChunkId"])
                    {
                        firstChunk = (int)chunkInfo["chunkId"];
                    }
                    else
                    {
                        firstChunk = (int)chunkInfo["startGameChunkId"];
                    }

                    if ((int)chunkInfo["keyFrameId"] > 0)
                    {
                        firstKeyFrame = (int)chunkInfo["keyFrameId"];
                    }
                    else
                    {
                        firstKeyFrame = 1;
                    }

                    lastChunk = (int)chunkInfo["chunkId"];
                    lastKeyFrame = (int)chunkInfo["keyFrameId"];

                    var chunk = Getter.GetChunkFrame(chunkInfo["chunkId"].ToString());
                    writer.WriteChunk(chunkInfo["chunkId"].ToString(), chunk);

                    var frame = Getter.GetKeyFrame(chunkInfo["keyFrameId"].ToString());
                    writer.WriteFrame(chunkInfo["keyFrameId"].ToString(), frame);
                }

                if ((int)chunkInfo["startGameChunkId"] > firstChunk)
                {
                    firstChunk = (int)chunkInfo["startGameChunkId"];
                }

                if ((int)chunkInfo["chunkId"] > lastChunk)
                {
                    for (int i = lastChunk + 1; i <= (int)chunkInfo["chunkId"]; i++)
                    {
                        var chunk = Getter.GetChunkFrame(i.ToString());
                        writer.WriteChunk(i.ToString(), chunk);
                    }
                }

                if (((int)chunkInfo["nextChunkId"] < (int)chunkInfo["chunkId"]) && ((int)chunkInfo["nextChunkId"] > 0))
                {
                    var chunk = Getter.GetChunkFrame(chunkInfo["nextChunkId"].ToString());
                    writer.WriteChunk(chunkInfo["nextChunkId"].ToString(), chunk);
                }

                if ((int)chunkInfo["keyFrameId"] > lastKeyFrame)
                {
                    for (int i = lastKeyFrame + 1; i <= (int)chunkInfo["keyFrameId"]; i++)
                    {
                        var frame = Getter.GetKeyFrame(chunkInfo["keyFrameId"].ToString());
                        writer.WriteFrame(chunkInfo["keyFrameId"].ToString(), frame);
                    }
                }

                writer.WriteChunkData((int)chunkInfo["keyFrameId"], firstChunk, (int)chunkInfo["startGameChunkId"], firstKeyFrame, (int)chunkInfo["chunkId"], (int)chunkInfo["endStartupChunkId"]);

                lastChunk = (int)chunkInfo["chunkId"];
                lastKeyFrame = (int)chunkInfo["keyFrameId"];

                if ((int)chunkInfo["endGameChunkId"] == (int)chunkInfo["chunkId"])
                {
                    if (FinishedRecording != null)
                        FinishedRecording(GameId);
                    return;
                }
                Util.Delay((int)chunkInfo["nextAvailableChunk"]);
            }
            #endregion
        }
    }
}
