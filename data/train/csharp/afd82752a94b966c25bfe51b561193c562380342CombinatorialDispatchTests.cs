using System;
using NUnit.Framework;

namespace MultiMethods.Tests
{
	[TestFixture]
	public class CombinatorialDispatchTests
	{
		[Test, Combinatorial]
		public void Combinatorial_Test_All_4_Argument_Dispatch(
			[Values("A", "B", "C", "D")] string arg1,
			[Values("A", "B", "C", "D")] string arg2,
			[Values("A", "B", "C", "D")] string arg3,
			[Values("A", "B", "C", "D")] string arg4)
		{
			A a1 = DispatchTestHelper.CreateInstance(arg1);
			A a2 = DispatchTestHelper.CreateInstance(arg2);
			A a3 = DispatchTestHelper.CreateInstance(arg3);
			A a4 = DispatchTestHelper.CreateInstance(arg4);

			DispatchTestHelper check = new DispatchTestHelper();

			string expected = arg1 + arg2 + arg3 + arg4;
			Assert.AreEqual(expected, check.FF4(a1, a2, a3, a4));
		}

		[Test, Combinatorial]
		public void Combinatorial_Test_All_3_Argument_Dispatch(
			[Values("A", "B", "C", "D")] string arg1,
			[Values("A", "B", "C", "D")] string arg2,
			[Values("A", "B", "C", "D")] string arg3)
		{
			A a1 = DispatchTestHelper.CreateInstance(arg1);
			A a2 = DispatchTestHelper.CreateInstance(arg2);
			A a3 = DispatchTestHelper.CreateInstance(arg3);

			DispatchTestHelper check = new DispatchTestHelper();

			string expected = arg1 + arg2 + arg3;
			Assert.AreEqual(expected, check.FF3(a1, a2, a3));
		}

		[Test, Combinatorial]
		public void Combinatorial_Test_All_2_Argument_Dispatch(
			[Values("A", "B", "C", "D")] string arg1,
			[Values("A", "B", "C", "D")] string arg2)
		{
			A a1 = DispatchTestHelper.CreateInstance(arg1);
			A a2 = DispatchTestHelper.CreateInstance(arg2);

			DispatchTestHelper check = new DispatchTestHelper();

			string expected = arg1 + arg2;
			Assert.AreEqual(expected, check.FF2(a1, a2));
		}

		[Test, Combinatorial]
		public void Combinatorial_Test_All_1_Argument_Dispatch(
			[Values("A", "B", "C", "D")] string arg1)
		{
			A a1 = DispatchTestHelper.CreateInstance(arg1);

			DispatchTestHelper check = new DispatchTestHelper();

			Assert.AreEqual(arg1, check.FF1(a1));
		}
	}
}
