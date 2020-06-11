using ParameterValidator;

namespace NetworkMessageReader
{
    public class DataChunk
    {
        public byte[] Chunk { get; private set; }
        public int Size { get; private set; }

        public DataChunk(byte[] dataChunk, int size)
        {
            ParameterValidator.ParameterValidator.EnsureParametersAreValid(new NullValidatorWithValue<byte[]>(() => dataChunk, dataChunk),
                                                                           new MinValueValidatorWithValue<int>(() => size, size, 0));
            Chunk = dataChunk;
            Size = size;
        }
    }
}