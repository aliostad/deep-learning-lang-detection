namespace client
{
    using System;

    public class PacketProcessInfo
    {
        private PacketProcess _isProcess;
        private WorldPacket _packet;

        public PacketProcessInfo(WorldPacket packet)
        {
            this._packet = packet;
            this._isProcess = PacketProcess.PACKETPROCESS_NULL;
        }

        public bool IsProcessed()
        {
            return (this._isProcess == PacketProcess.PACKETPROCESS_PROCESS);
        }

        public bool IsSend()
        {
            return (this._isProcess != PacketProcess.PACKETPROCESS_NULL);
        }

        public void Process()
        {
            this._isProcess = PacketProcess.PACKETPROCESS_PROCESS;
        }

        public void Reset()
        {
            this._isProcess = PacketProcess.PACKETPROCESS_NULL;
        }

        public void Send()
        {
            this._isProcess = PacketProcess.PACKETPROCESS_SEND;
        }

        public WorldPacket Packet
        {
            get
            {
                return this._packet;
            }
        }
    }
}

