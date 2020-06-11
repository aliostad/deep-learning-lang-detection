#if !TRAVIS_CI
using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using System.IO;
using System.Threading.Tasks;
using System.Threading;

namespace TestSharp.Tests
{
	[TestFixture()]
	public class ProcessHelperTest
	{
		#region Fields
		private string m_processPath;
		private string m_processName;
		private string m_processArgs;
		#endregion

		[TestFixtureSetUp]
		public void Initialize()
		{
			if(Environment.OSVersion.Platform == PlatformID.MacOSX || Environment.OSVersion.Platform == PlatformID.Unix)
			{
				m_processPath = "vim";
				m_processName = "vim";
				m_processArgs = String.Empty;
			}
			else 
			{
				m_processPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.System), @"calc.exe");
				m_processName = "calc";
				m_processArgs = String.Empty;
			}
		}

		[Test]
		public void CountInstancesTest()
		{
			ProcessHelper.KillAll(m_processName);
			ProcessAssert.IsProcessInstancesCount(0, m_processName);

			ProcessHelper.Run(m_processPath, m_processArgs, false);
			ProcessAssert.IsProcessInstancesCount(1, m_processName);

			ProcessHelper.Run(m_processPath, m_processArgs, false);
			ProcessAssert.IsProcessInstancesCount(2, m_processName);

			ProcessHelper.Run(m_processPath, m_processArgs, false);
			ProcessAssert.IsProcessInstancesCount(3, m_processName);

			ProcessHelper.KillAll(m_processName);
			ProcessAssert.IsProcessInstancesCount(0, m_processName);
		}

		[Test]
		public void KillAllTest()
		{
			ProcessHelper.KillAll(m_processName);
			ProcessAssert.IsProcessInstancesCount(0, m_processName);

			ProcessHelper.Run(m_processPath, m_processArgs, false);
			ProcessHelper.Run(m_processPath, m_processArgs, false);
			ProcessHelper.Run(m_processPath, m_processArgs, false);
			
			ProcessAssert.IsProcessInstancesCount(3, m_processName);
			ProcessHelper.KillAll(m_processName);
			ProcessAssert.IsProcessInstancesCount(0, m_processName);

			Parallel.For(0, 100, (i) =>
			{
				try
				{
					ProcessHelper.Run(m_processPath, m_processArgs, false);
				}
				catch
				{
					// Just for test.
				}

				ProcessHelper.KillAll(m_processName);
			});
		}

		[Test]
		public void KillFirstTest()
		{
			ProcessHelper.KillFirst(m_processName);
			ProcessAssert.IsProcessInstancesCount(0, m_processName);

			ProcessHelper.Run(m_processPath, m_processArgs, false);
			ProcessHelper.Run(m_processPath, m_processArgs, false);
			ProcessHelper.Run(m_processPath, m_processArgs, false);

			ProcessAssert.IsProcessInstancesCount(3, m_processName);
			ProcessHelper.KillFirst(m_processName);
			ProcessAssert.IsProcessInstancesCount(2, m_processName);

			ProcessHelper.KillFirst(m_processName);
			ProcessAssert.IsProcessInstancesCount(1, m_processName);

			ProcessHelper.KillFirst(m_processName);
			ProcessAssert.IsProcessInstancesCount(0, m_processName);
		}
// TODO: check how to make this test to MacOSX too.
//		[Test]
//		public void RunWithFullPathTest()
//		{
//			var processName = @"c:\Windows\System32\cmd.exe";
//			var args = @"dir";
//
//			var actualOutput = ProcessHelper.Run(processName, args);
//			Assert.IsFalse(String.IsNullOrEmpty(actualOutput));
//			StringAssert.StartsWith("Microsoft", actualOutput);
//			StringAssert.EndsWith("Out>", actualOutput);
//
//			actualOutput = ProcessHelper.Run(processName, args, false);
//			Assert.IsTrue(String.IsNullOrEmpty(actualOutput));
//		}
//
//		[Test]
//		public void RunWithSystemVariableTest()
//		{
//			var processName = @"%windir%\system32\cmd.exe";
//			var args = @"dir";
//
//			var actualOutput = ProcessHelper.Run(processName, args);
//			Assert.IsFalse(String.IsNullOrEmpty(actualOutput));
//			StringAssert.StartsWith("Microsoft", actualOutput);
//			StringAssert.EndsWith("Out>", actualOutput);
//
//			actualOutput = ProcessHelper.Run(processName, args, false);
//			Assert.IsTrue(String.IsNullOrEmpty(actualOutput));
//		}

		[Test]
		public void WaitForExitTest()
		{
			Parallel.Invoke(
				() =>
				{
				ProcessHelper.Run(m_processPath, m_processArgs, false);
					var beforeTime = DateTime.Now;
					ProcessHelper.WaitForExit(m_processName);
					Assert.AreNotEqual(beforeTime, DateTime.Now);
				},
				() =>
				{
					Thread.Sleep(1000);
					ProcessHelper.KillAll(m_processName);
				}
				);
		}
	}
}
#endif
