using Vancl.TMS.IBLL.Transport.Dispatch;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using Vancl.TMS.Model.Transport.Dispatch;
using System.Collections.Generic;
using Vancl.TMS.Model.Transport.PreDispatch;
using Vancl.TMS.Core.ServiceFactory;

namespace TMS.Service.UnitTest
{
    
    
    /// <summary>
    ///这是 IPreDispatchBLLTest 的测试类，旨在
    ///包含所有 IPreDispatchBLLTest 单元测试
    ///</summary>
    [TestClass()]
    public class IPreDispatchBLLTest
    {


        private TestContext testContextInstance;

        /// <summary>
        ///获取或设置测试上下文，上下文提供
        ///有关当前测试运行及其功能的信息。
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region 附加测试特性
        // 
        //编写测试时，还可使用以下特性:
        //
        //使用 ClassInitialize 在运行类中的第一个测试前先运行代码
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //使用 ClassCleanup 在运行完类中的所有测试后再运行代码
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //使用 TestInitialize 在运行每个测试前先运行代码
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //使用 TestCleanup 在运行完每个测试后运行代码
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        internal virtual IPreDispatchBLL CreateIPreDispatchBLL()
        {
            // TODO: 实例化相应的具体类。
            IPreDispatchBLL target = ServiceFactory.GetService<IPreDispatchBLL>("PreDispatchBLL"); ;
            return target;
        }

        /// <summary>
        ///GetPreDispatchBoxList 的测试
        ///</summary>
        [TestMethod()]
        public void GetPreDispatchBoxListTest()
        {
            IPreDispatchBLL target = CreateIPreDispatchBLL(); // TODO: 初始化为适当的值
            int LPID = 0; // TODO: 初始化为适当的值
            List<ViewDispatchBoxModel> expected = null; // TODO: 初始化为适当的值
            List<ViewDispatchBoxModel> actual;
            actual = target.GetPreDispatchBoxList(LPID);
            Assert.AreEqual(expected, actual);
            Assert.Inconclusive("验证此测试方法的正确性。");
        }

        /// <summary>
        ///PreDispatch 的测试
        ///</summary>
        [TestMethod()]
        public void PreDispatchTest()
        {
            IPreDispatchBLL target = CreateIPreDispatchBLL(); // TODO: 初始化为适当的值
            PreDispatchJobArgModel arguments = new PreDispatchJobArgModel() 
            {
                PerBatchCount = 300,
                IntervalDay = 10           
            }; // TODO: 初始化为适当的值
            target.PreDispatch(arguments);
        }
    }
}
