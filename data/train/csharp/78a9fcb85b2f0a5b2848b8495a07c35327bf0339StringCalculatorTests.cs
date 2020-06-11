using NUnit.Framework;

namespace StringCalculator
{
    using System;

    [TestFixture]
    public class StringCalculatorTests
    {
        
        [Test]
        public void Calculate_EmptyString_Returns0()
        {
            Assert.AreEqual(0, Calculator.Calculate(string.Empty));
        }

        [Test]
        public void Calculate_InputNull_Returns0()
        {
            Assert.AreEqual(0, Calculator.Calculate(null));
        }

        [ExpectedException(typeof(ArgumentException))]
        [Test]
        public void Calculate_stringNotNumeric_ThrowsException()
        {
            Calculator.Calculate("blabl");
        }

        [Test]
        public void Calculate_ThreePlusFour_ReturnsSeven()
        {
            Assert.AreEqual(7, Calculator.Calculate("3+4"));
        }

        [Test]
        public void Calculate_4Times2_8()
        {
            Assert.AreEqual(8, Calculator.Calculate("4*2"));
        }

        [ExpectedException(typeof(ArgumentException))]
        [Test]
        public void Calculate_3Plus_ThrowsArgumentException()
        {
             Calculator.Calculate("3+");
        }
        
        [ExpectedException(typeof(ArgumentException))]
        [Test]
        public void Calculate_3Times_ThrowsArgumentException()
        {
             Calculator.Calculate("3*");
        }
        
        [ExpectedException(typeof(ArgumentException))]
        [Test]
        public void Calculate_Times3_ThrowsArgumentException()
        {
             Calculator.Calculate("*3");
        }

        [Test]
        public void Calculate_77_7()
        {
            Assert.AreEqual(7, Calculator.Calculate("77"));
        }

        [Test]
        public void Calculate_3Plus4_7()
        {
            Assert.AreEqual(7, Calculator.Calculate("3plus4"));
        }

        [Test]
        public void Calculate_WithSpaces_ReturnsSameResult()
        {
            Assert.AreEqual(6, Calculator.Calculate("3 + 3"));
        }

        [Test]
        public void Calculate_8Divide2_Returns4()
        {
            Assert.AreEqual(4, Calculator.Calculate("8/2"));
        }

        [Test]
        public void Calculate_3Divide2_Returns1()
        {
            Assert.AreEqual(1, Calculator.Calculate("3/2"));
        }

        [Test]
        [ExpectedException(typeof(DivideByZeroException))]
        public void Calculate_DivideBy0_ThrowsException()
        {
            Calculator.Calculate("1/0");
        }

        [Test]
        public void Calculate_7Modulus2_Returns1()
        {
            Assert.AreEqual(1, Calculator.Calculate("7%2"));
        }

        [Test]
        public void Calculate_minus3plus2_Returns1()
        {
            Assert.AreEqual(-1, Calculator.Calculate("-3+2"));
        }

        [Test]
        public void Calculate_2plusminus4_ReturnsMinus2()
        {
            Assert.AreEqual(-2, Calculator.Calculate("2+-4"));
        }

        [Test]
        public void Calculate_2plus3minus4_Returns1()
        {
            Assert.AreEqual(1, Calculator.Calculate("2+3-4"));
        }

        [Test]
        public void Calculate_2plus9divideby3minus3_Returns1()
        {
            Assert.AreEqual(1, Calculator.Calculate("2+9/3-4"));
        }

        [Test]
        public void Calculate_2times4minus3divideby3_Returns7()
        {
            Assert.AreEqual(7, Calculator.Calculate("2*4-3/3"));
        }

        [Test]
        public void Calculate_10divideby5times2_Returns14()
        {
            Assert.AreEqual(14, Calculator.Calculate("10/5*7"));
        }

        [Test]
        public void Calculate_10times5divideby7_Returns7()
        {
            Assert.AreEqual(7, Calculator.Calculate("10*5/7"));
        }

        [Test]
        public void Calculate_3minusminus3_Returns6()
        {
            Assert.AreEqual(6, Calculator.Calculate("3--3"));
        }
    }
}
