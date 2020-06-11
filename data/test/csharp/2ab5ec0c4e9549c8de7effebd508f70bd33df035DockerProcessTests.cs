namespace com.smerkel.DockerProcess.UnitTests
{
    using Xunit;
    using IDockerProcess;

    public class DockerProcessTests
    {
        private readonly IDockerProcess _dockerProcess;

        public DockerProcessTests()
        {
            // Arrange
            _dockerProcess = new DockerProcess();
        }

        [Fact]
        public void DockerProcessNotNull()
        {
            Assert.NotNull(_dockerProcess);
        }

        [Fact]
        public void Images()
        {
            // Act
            var result = _dockerProcess.Images(null);

            // Assert
            Assert.NotNull(result);
        }
    }
}
