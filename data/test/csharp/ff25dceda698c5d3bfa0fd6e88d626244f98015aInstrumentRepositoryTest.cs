using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using PracticeTime.Web.DataAccess.Models;
using PracticeTime.Web.DataAccess.Repositories;

namespace PracticeTime.Web.DataAccess.Test.Repositories
{
    [TestClass]
    public class InstrumentRepositoryTest
    {
        [TestMethod]
        public void ConstructorTest()
        {
            InstrumentRepository repo = new InstrumentRepository();
            Assert.IsNotNull(repo);
        }

        [TestMethod]
        public void GetAllTest()
        {
            InstrumentRepository repo = new InstrumentRepository();
            List<C_Instrument> instruments = repo.GetAll();
            Assert.IsTrue(instruments.Count > 0);
        }

        [TestMethod]
        public void GetByIdTest()
        {
            InstrumentRepository repo = new InstrumentRepository();
            C_Instrument instrument = repo.GetById(1);
            Assert.IsNotNull(instrument);
            Assert.IsNotNull(instrument.Name);
            Assert.IsNotNull(instrument.Description);
            Assert.IsNotNull(instrument.IconUrl);
        }
    }
}
