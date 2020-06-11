using System.Diagnostics;
using NUnit.Framework;
using pdfforge.PDFCreator.Utilities.Process;

namespace pdfforge.PDFCreator.Utilities.Test.Process
{
    [TestFixture]
    class ProcessWrapperTest
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
