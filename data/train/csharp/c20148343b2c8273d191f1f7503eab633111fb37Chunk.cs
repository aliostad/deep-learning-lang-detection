using System.IO;

namespace Resources.Packet {
    public class Chunk {
        public const int packetID = 11;

        public int chunkX;
        public int chunkY;

        public Chunk() { }

        public Chunk(BinaryReader reader) {
            chunkX = reader.ReadInt32();
            chunkY = reader.ReadInt32();
        }

        public void Write(BinaryWriter writer, bool writePacketID = true) {
            if(writePacketID) {
                writer.Write(packetID);
            }
            writer.Write(chunkX);
            writer.Write(chunkY);
        }
    }
}
