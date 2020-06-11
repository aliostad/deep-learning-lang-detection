#region Using
using System;
using System.Data.Hsqldb.TestCoverage;
using NUnit.Framework; 
#endregion

namespace System.Data.Hsqldb.Client.UnitTests
{
    [TestFixture, ForSubject(typeof(HsqlRowUpdatedEventHandler))]
    public class TestHsqlRowUpdatedEventHandler
    {
        [Test, OfMember("BeginInvoke")]
        public void BeginInvoke()
        {
        }

        [Test, OfMember("EndInvoke")]
        public void EndInvoke()
        {
        }

        [Test, OfMember("Invoke")]
        public void Invoke()
        {
        }
    }
}
