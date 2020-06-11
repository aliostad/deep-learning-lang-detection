using System;
using System.Diagnostics;
using System.Threading;
using NUnit.Framework;
using Oleg.Kleyman.Tests.Core;

namespace Oleg.Kleyman.Core.Tests.Integration
{
    [TestFixture]
    public class SystemProcessTests : TestsBase
    {
        private ProcessStartInfo _processInfo;

        public override void Setup()
        {
            _processInfo = new ProcessStartInfo(@"cmd.exe")
                {
                    CreateNoWindow = true,
                    WindowStyle = ProcessWindowStyle.Hidden,
                    UseShellExecute = true
                };
        }

        [Test]
        public void ConstructorTest()
        {
            var processManager = new ProcessManager();

            var process = processManager.Start(_processInfo);
            Assert.IsInstanceOf<SystemProcess>(process);
            Assert.IsFalse(process.HasExited);
            Assert.AreEqual(ProcessPriorityClass.Normal, process.PriorityClass);
            process.Kill();
            process.WaitForExit();
            Assert.AreEqual(true, process.HasExited);
        }

        [Test]
        public void HasExitedTest()
        {
            var processManager = new ProcessManager();

            var process = processManager.Start(_processInfo);
            Assert.IsFalse(process.HasExited);
            process.Kill();
            process.WaitForExit();
            Assert.IsTrue(process.HasExited);
        }

        [Test]
        public void KillTest()
        {
            var processManager = new ProcessManager();

            var process = processManager.Start(_processInfo);
            Assert.IsFalse(process.HasExited);
            process.Kill();
            process.WaitForExit();
            Assert.IsTrue(process.HasExited);
        }

        [Test]
        public void PriorityClassest()
        {
            var processManager = new ProcessManager();

            var process = processManager.Start(_processInfo);
            ;
            Assert.AreEqual(ProcessPriorityClass.Normal, process.PriorityClass);
            process.Kill();
            process.WaitForExit();
            Assert.AreEqual(true, process.HasExited);
        }

        [Test]
        public void WaitForExitTest()
        {
            var processManager = new ProcessManager();

            var process = processManager.Start(_processInfo);
            var action = new Action(() =>
                {
                    process.WaitForExit();
                    Assert.IsTrue(process.HasExited);
                });
            var asyncResult = action.BeginInvoke(null, null);

            Assert.IsFalse(process.HasExited);
            Thread.Sleep(2000);
            process.Kill();
            action.EndInvoke(asyncResult);
        }
    }
}