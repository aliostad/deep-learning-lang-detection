using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameServer.Server;

namespace GameServer.Logic
{
    public class PorcessCmdMoniter
    {
        public int cmd;
        public int processNum = 0;
        public long processTotalTime = 0;
        public long processMaxTime = 0;
        public long waitProcessTotalTime = 0;
        public long maxWaitProcessTime = 0;

        public long Num_Faild;
        public long Num_OK;
        public long Num_WithData;

        public PorcessCmdMoniter(int cmd, long processTime)
        {
            this.cmd = cmd;
            processNum++;
            processTotalTime += processTime;
            processMaxTime = processTime;
        }

        public void onProcess(long processTime, long waitTime)
        {
            processNum++;
            processTotalTime += processTime;
            processMaxTime = processMaxTime >= processTime ? processMaxTime : processTime;
            waitProcessTotalTime += waitTime;
            maxWaitProcessTime = maxWaitProcessTime >= waitTime ? maxWaitProcessTime : waitTime;
        }

        public void onProcessNoWait(long processTime, TCPProcessCmdResults result)
        {
            processNum++;
            processTotalTime += processTime;
            if (processMaxTime >= processTime)
            {
                processMaxTime = processTime;
            }
            switch (result)
            {
                case TCPProcessCmdResults.RESULT_FAILED:
                    Num_Faild++;
                    break;
                case TCPProcessCmdResults.RESULT_OK:
                    Num_OK++;
                    break;
                case TCPProcessCmdResults.RESULT_DATA:
                    Num_WithData++;
                    break;
            }
        }

        public long avgProcessTime()
        {
            return processNum > 0 ? processTotalTime / processNum : 0;
        }

        public long avgWaitProcessTime()
        {
            return processNum > 0 ? waitProcessTotalTime / processNum : 0;
        }
    }
}
