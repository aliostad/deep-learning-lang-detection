using Microsoft.VisualStudio.TestTools.UnitTesting;
using OvningsTenta4.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OvningsTenta4.Models.Tests
{
    [TestClass()]
    public class CalculateEnergyTests
    {
        [TestMethod()]
        public void CalculateMassTest()
        {
            Assert.Fail();
        }

        [TestMethod]
        public void CalculateEnergy_Default()
        {
            //arrange
            CalculateEnergy calculateEnergy = new CalculateEnergy();
            //act
            var actual = calculateEnergy.CalculateMass("1");
            var expected = 89875517873681764;
            //assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void CalculateEnergy_PositiveNumber()
        {
            CalculateEnergy calculateEnergy = new CalculateEnergy();

            var actual = calculateEnergy.CalculateMass("5");
            var expected = 449377589368408820;
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void CalculateEnergy_NegativeNumber()
        {
            CalculateEnergy calculateEnergy = new CalculateEnergy();

            var actual = calculateEnergy.CalculateMass("-5");
            var expected = -449377589368408820;
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        [ExpectedException(typeof(FormatException))]
        public void CalculateEnergy_Exception()
        {
            CalculateEnergy calculateEnergy = new CalculateEnergy();
            calculateEnergy.CalculateMass("");
        }
    }
}