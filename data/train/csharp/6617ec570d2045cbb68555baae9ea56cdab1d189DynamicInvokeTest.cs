using System;
using System.Reflection;
using System.Reflection.Emit;
using System.Text;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Allen.Util.TestUtil;
using CSharpFeatures.Dynamic;
using SysExpression = System.Linq.Expressions;

namespace CSharpFeaturesTest.Dynamic
{

    /// <summary>
    /// Summary description for DynamicInvokeTest
    /// </summary>
    [TestClass]
    public class DynamicInvokeTest
    {
        delegate void JobAction(int i);

        public DynamicInvokeTest()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext { get; set; }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        [ClassInitialize()]
        public static void MyClassInitialize(TestContext testContext)
        {
            CodeTimer.Initialize();
            InvokeTimes = 1000;
            CreateTimes = 10000;
        }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        [ClassCleanup()]
        public static void MyClassCleanup()
        {
        }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{

        //}
        //
        #endregion

        #region tests with create env
        public void DirectInvokeTest()
        {
            CodeTimer.Time("DirectInvokeTest", InvokeTimes, DirectInvoke);
        }
        public void InterfaceInvokeTest()
        {
            CodeTimer.Time("InterfaceInvokeTest", InvokeTimes, InterfaceInvoke);
        }
        public void DelegateInvokeTest()
        {
            CodeTimer.Time("DelegateInvokeTest", InvokeTimes, DelegateInvoke);
        }
        public void LambdaInvokeTest()
        {
            CodeTimer.Time("LambdaInvokeTest", InvokeTimes, LambdaInvoke);
        }
        public void ReflectionInvokeTest()
        {
            CodeTimer.Time("ReflectionInvoke", InvokeTimes, ReflectionInvoke);
        }
        public void DynamicInstanceInvokeTest()
        {
            CodeTimer.Time("DynamicInvoke", InvokeTimes, DynamicInvoke);
        }
        public void IlEmitInvokeTest()
        {
            CodeTimer.Time("IL Emit Invoke", InvokeTimes, IlEmitInvoke);
        }
        public void GenerateDelegateInvokeTest()
        {
            CodeTimer.Time("Generate Delegate Invoke", InvokeTimes, GenerateDelegateInvoke);
        }

        #endregion

        #region tests split create env
        public void DirectInvokeTest2()
        {
            var obj = new InvokeMethod();
            CodeTimer.Time("DirectInvokeTest.Create", CreateTimes, () => new InvokeMethod());
            CodeTimer.Time("DirectInvokeTest", InvokeTimes, () => obj.Do(InvokeTimes));
        }
        public void ReflectionInvokeTest2()
        {
            var obj = new InvokeMethod();
            MethodInfo m = null;
            CodeTimer.Time("ReflectionInvoke.Create", CreateTimes, () => m = CreateMethodInfo(obj));
            CodeTimer.Time("ReflectionInvoke", InvokeTimes, () => ReflectionInvoke(m, obj));
        }
        public void LambdaInvokeTest2()
        {
            var obj = new InvokeMethod();
            Action<InvokeMethod, int> a =
                CodeTimer.Time<int, Action<InvokeMethod, int>>("LambdaInvokeTest.Create",
                    CreateTimes, (int i) => CreateLambda(), InvokeTimes);

            CodeTimer.Time<Tuple<InvokeMethod, Action<InvokeMethod, int>, int>, object>("LambdaInvokeTest", InvokeTimes, (tuple) =>
            {
                tuple.Item2(tuple.Item1, tuple.Item3);
                return null;
            }, new Tuple<InvokeMethod, Action<InvokeMethod, int>, int>(obj, a, InvokeTimes));// Tuple<InvokeMethod, Action<InvokeMethod, int>>());
        }
        public void DelegateInvokeTest2()
        {
            var obj = new InvokeMethod();
            Action<int> a = null;
            CodeTimer.Time("DelegateInvokeTest.Create", CreateTimes, () => a = CreateDelegate(obj));
            CodeTimer.Time("DelegateInvokeTest", InvokeTimes, () => a.Invoke(InvokeTimes));
        }

        [TestMethod]
        public void DynamicInvokeTest2()
        {
            CodeTimer.Time("DynamicInvokeTest.Create", CreateTimes, () => { dynamic a = new InvokeMethod(); });
            dynamic b = new InvokeMethod();
            CodeTimer.Time("DynamicInvokeTest", InvokeTimes, () => b.Do(InvokeTimes));
        }
        [TestMethod]
        public void IlEmitInvokeTest2()
        {

            Action<InvokeMethod, int> a = null;
            CodeTimer.Time("IL Emit InvokeTest.Create", CreateTimes, () => a = CreateIlMethod());

            var obj = new InvokeMethod();
            CodeTimer.Time("IL Emit InvokeTest", InvokeTimes, () => a.Invoke(obj, InvokeTimes));
        }
        public void GenerateDelegateInvokeTest2()
        {

            JobAction a = null;
            CodeTimer.Time("Generate Delegate Create", CreateTimes, () => a = CreateDelegateAction());


            CodeTimer.Time("Generated Delegate InvokeTest", InvokeTimes, () => a(InvokeTimes));
        }
        #endregion


        [TestCategory("DynamicInvoke"), TestMethod]
        public void AllTest()
        {
            DirectInvokeTest();
            InterfaceInvokeTest();
            DelegateInvokeTest();
            LambdaInvokeTest();
            ReflectionInvokeTest();
            DynamicInstanceInvokeTest();
            IlEmitInvokeTest();
            GenerateDelegateInvokeTest();
        }
        [TestCategory("DynamicInvoke"), TestMethod]
        public void AllTestSplitCreateTime()
        {
            DirectInvokeTest2();
            //InterfaceInvokeTest2();
            DelegateInvokeTest2();
            LambdaInvokeTest2();
            ReflectionInvokeTest2();
            DynamicInvokeTest2();
            IlEmitInvokeTest2();
            GenerateDelegateInvokeTest2();
        }

        #region Excute

        /// <summary>
        /// 迭代执行次数
        /// </summary>
        public static int InvokeTimes { get; set; }
        public static int CreateTimes { get; set; }

        public static void DirectInvoke()
        {
            var obj = new InvokeMethod();
            obj.Do(InvokeTimes);
        }
        public static void InterfaceInvoke()
        {
            IInvokeMethod obj = new InvokeMethod();
            obj.Do(InvokeTimes);
        }

        public static void ReflectionInvoke()
        {
            var obj = new InvokeMethod();
            var m = CreateMethodInfo(obj);
            m.Invoke(obj, new object[] { InvokeTimes });
        }

        public static void DynamicInvoke()
        {
            dynamic obj = new InvokeMethod();
            obj.Do(InvokeTimes);
        }
        public static void DelegateInvoke()
        {
            var obj = new InvokeMethod();
            var action = CreateDelegate(obj);
            action(InvokeTimes);
        }
        public static void LambdaInvoke()
        {
            var obj = new InvokeMethod();
            var action = CreateLambda();
            action.Invoke(obj, InvokeTimes);
        }
        [TestMethod]
        public void IlEmitInvoke()
        {
            var add = CreateIlMethod();
            //
            var obj = new InvokeMethod();
            add(obj, InvokeTimes);
        }

        [TestMethod]
        public void GenerateDelegateInvoke()
        {
            var action = CreateDelegateAction();
            action(InvokeTimes);
        }

        private static JobAction CreateDelegateAction()
        {
            var obj = new InvokeMethod();
            var action = Delegate.CreateDelegate(typeof(JobAction), obj, CreateMethodInfo(obj)) as JobAction;
            return action;
        }

        private static Action<InvokeMethod, int> CreateIlMethod()
        {
            var doMethod = typeof(InvokeMethod).GetMethod("Do");
            var dynamicMethod = new DynamicMethod("IlEmitInvokeTest", null, new[] { typeof(InvokeMethod), typeof(int) });
            //
            var il = dynamicMethod.GetILGenerator();
            il.Emit(OpCodes.Ldarg_0);
            il.Emit(OpCodes.Ldarg_1);
            il.Emit(OpCodes.Callvirt, doMethod);
            il.Emit(OpCodes.Ret);
            //
            var add = (Action<InvokeMethod, int>)dynamicMethod.CreateDelegate(typeof(Action<InvokeMethod, int>));
            return add;
        }


        public static void ReflectionInvoke(MethodInfo m, InvokeMethod obj)
        {
            //var obj = new InvokeMethod();
            //var m = CreateMethodInfo(obj);
            m.Invoke(obj, new object[] { InvokeTimes });
        }

        //public static void EmitInfoke()
        //{

        //}
        #endregion

        #region PrepareEnvironment

        private static MethodInfo CreateMethodInfo(InvokeMethod obj)
        {
            var t = typeof(InvokeMethod);
            var m = t.GetMethod("Do");

            return m;
        }
        private static Action<int> CreateDelegate(InvokeMethod obj)
        {
            var action = new Action<int>(obj.Do);
            return action;
        }
        //private static Action<int> CreateLambda(InvokeMethod obj)
        //{
        //    Expression<Action<int>> lambda = (int i) => obj.Do(i);
        //    var action = lambda.Compile();
        //    return action;
        //}

        private static Action<InvokeMethod, int> CreateLambda()
        {
            var param_im = SysExpression.Expression.Parameter(typeof(InvokeMethod), "im");
            var param_i = SysExpression.Expression.Parameter(typeof(int), "i");
            //var createObj = Expression.New(typeof(InvokeMethod));
            //var lambda = Expression.Lambda<Action<int>>(
            //    Expression.Call(typeof(InvokeMethod), "Do", new Type[] { typeof(int) }, new Expression[] { param_i }));
            var lambda = SysExpression.Expression.Lambda<Action<InvokeMethod, int>>(
                SysExpression.Expression.Call(param_im, typeof(InvokeMethod).GetMethod("Do"), param_i), param_im, param_i);

            SysExpression.Expression<Action<InvokeMethod, int>> lambda2 = (im, i) => im.Do(i);

            var action = lambda.Compile();
            return action;
        }

        #endregion

        [TestMethod]
        public void DynamicCallTest()
        {
            dynamic d = new InvokeMethod();
            Assert.IsNotNull(d.Str);


            dynamic d2 = Activator.CreateInstance("CSharpFeatures", "CSharpFeatures.Dynamic.InvokeMethod2");
            Assert.AreEqual("InvokeMethod2", d2.Str);

            dynamic d3 = InvokeMethod.GetInstance();
            Assert.AreEqual("InvokeMethod2", d3.Str);
        }

    }
}
