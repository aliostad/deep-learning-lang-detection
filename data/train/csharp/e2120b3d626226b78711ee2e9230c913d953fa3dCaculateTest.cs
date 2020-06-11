using System;

using System.Collections.Generic;

using System.Linq;

using System.Text;

using NUnit.Framework;

namespace IQuickTest
{

    [TestFixture]

    public class CalculateTest
    {

        [Test]

        public void AddTest()
        {

            int expected = 12;

            Calculate calculate = new Calculate();

            Assert.AreEqual(expected, calculate.add(9, 3));

            Assert.AreNotEqual(expected, calculate.add(9, 2));

        }

        [Test]

        public void SubTest()
        {

            int expected = 8;

            Calculate calculate = new Calculate();

            Assert.AreEqual(expected, calculate.sub(10, 2));

            Assert.AreNotEqual(expected, calculate.sub(10, 0));

        }

    }

}
