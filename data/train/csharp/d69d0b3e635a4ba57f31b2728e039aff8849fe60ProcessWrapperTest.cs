using NUnit.Framework;
using pdfforge.PDFCreator.Utilities.Process;
using System.Diagnostics;

namespace pdfforge.PDFCreator.Utilities.UnitTest.Process
{
    [TestFixture]
    internal class ProcessWrapperTest
    {
        [Test]
        public void ProcessWrapperFactory_WithProcessStartInfo_WrapsProcessWithSameStartupInfo()
        {
            var processWrapperFactory = new ProcessWrapperFactory();
            var processStartInfo = new ProcessStartInfo();

            var process = processWrapperFactory.BuildProcessWrapper(processStartInfo);

            Assert.AreSame(processStartInfo, process.StartInfo);
        }
    }
}
