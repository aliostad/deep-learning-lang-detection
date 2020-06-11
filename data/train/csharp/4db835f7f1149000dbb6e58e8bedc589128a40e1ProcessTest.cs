using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tester.Test
{
    [TestClass]
    public class ProcessTest
    {
        [TestMethod]
        public void TestEachProcess()
        {
            Applications application = ApplicationTest.findApplication(); 

            application.Processes.ForEach(delegate(Process process)
            {
                Assert.IsTrue(process.processID != null && process.processID != 0);
                Assert.IsNotNull(process.processDescription);
                Assert.IsTrue(process.getHandle() != IntPtr.Zero);
                Assert.IsNotNull(process.getHandle());
                Assert.IsNotNull(process.processOwner);

            }); 

      

        }
    }
}
