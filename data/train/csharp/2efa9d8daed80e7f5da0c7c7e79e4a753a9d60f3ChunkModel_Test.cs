using NUnit.Framework;

namespace Peto.Test.Models {
    [TestFixture]
    class ChunkModel_Test {
        private ChunkModel chunkModel;

        [SetUp]
        public void SetUp() {
            this.chunkModel = new ChunkModel();
        }

        [TearDown]
        public void TearDown() {
            this.chunkModel = null;
        }

        [Test]
        public void ChunkModel_Id_AreEqual() {
            this.chunkModel.Id = 1;
            Assert.AreEqual(1, this.chunkModel.Id);
        }

        [Test]
        public void ChunkModel_ChunkTypeId_AreEqual() {
            this.chunkModel.ChunkTypeId = 1;
            Assert.AreEqual(1, this.chunkModel.ChunkTypeId);
        }

        [Test]
        public void ChunkModel_ChunkType_IsNotNull() {
            this.chunkModel.ChunkType = new ChunkTypeModel();
            Assert.IsNotNull(this.chunkModel.ChunkType);
        }

        [Test]
        public void ChunkModel_ChunkType_IsInstanceOf() {
            this.chunkModel.ChunkType = new ChunkTypeModel();
            Assert.IsInstanceOf(typeof(ChunkTypeModel), this.chunkModel.ChunkType);
        }
    }
}
