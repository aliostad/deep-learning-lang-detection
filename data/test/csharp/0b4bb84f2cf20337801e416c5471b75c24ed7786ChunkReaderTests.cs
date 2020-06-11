namespace AjTalk.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ChunkReaderTests
    {
        [TestMethod]
        [DeploymentItem(@"CodeFiles\FileOut01.st")]
        public void ReadFirstChunk()
        {
            ChunkReader reader = new ChunkReader(@"FileOut01.st");

            string chunk = reader.GetChunk();

            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.StartsWith("'"));
            reader.Close();
        }

        [TestMethod]
        [DeploymentItem(@"CodeFiles\DefineRectangle.st")]
        public void ReadDefineRectangle()
        {
            ChunkReader reader = new ChunkReader(@"DefineRectangle.st");

            string chunk = reader.GetChunk();

            Assert.IsNotNull(chunk);
            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.StartsWith("!"));
            reader.Close();
        }

        [TestMethod]
        [DeploymentItem(@"Library\Behavior.st")]
        public void ReadLibraryBehavior()
        {
            ChunkReader reader = new ChunkReader(@"Behavior.st");

            string chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);

            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsFalse(chunk.StartsWith("!"));

            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.StartsWith("!"));

            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsFalse(chunk.StartsWith("!"));

            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsFalse(chunk.StartsWith("!"));

            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsFalse(chunk.StartsWith("!"));

            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.StartsWith("!"));

            reader.Close();
        }

        [TestMethod]
        [DeploymentItem(@"CodeFiles\Transactions.st")]
        public void ReadBangSkippingNewLines()
        {
            ChunkReader reader = new ChunkReader(@"Transactions.st");

            string chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.StartsWith("!"));

            reader.Close();
        }

        [TestMethod]
        [DeploymentItem(@"CodeFiles\FileOut01.st")]
        public void ReadChunksWithExclamationMarksAndSpace()
        {
            ChunkReader reader = new ChunkReader(@"FileOut01.st");

            string chunk = reader.GetChunk();

            Assert.IsNotNull(chunk);
            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.Contains("\r"));
            Assert.IsTrue(chunk.Contains("\r\n"));
            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.StartsWith("!"));
            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.IsTrue(chunk.StartsWith("!"));
            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            chunk = reader.GetChunk();
            Assert.IsNotNull(chunk);
            Assert.AreEqual(" ", chunk);
            reader.Close();
        }

        [TestMethod]
        public void ProcessDoubleBang()
        {
            ChunkReader reader = new ChunkReader(new StringReader("!!new! !!new"));

            Assert.AreEqual("!new", reader.GetChunk());
            Assert.AreEqual(" !new", reader.GetChunk());
            Assert.IsNull(reader.GetChunk());
            reader.Close();
        }
    }
}
