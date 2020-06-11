using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ToracLibrary.Core.ReflectionDynamic.Invoke;
using ToracLibrary.Core.ReflectionDynamic.Invoke.Parameters;
using Xunit;

namespace ToracLibrary.UnitTest.Core
{

    public class InvokeTest
    {

        #region Framework

        private class InvokeRegularMethod
        {

            #region Constants

            public const int InvokeStaticMethodResult = 5;

            #endregion

            #region Static Methods

            public static int InvokeStaticMethod()
            {
                return InvokeStaticMethodResult;
            }

            public static int InvokeStaticMethodWithParameter(int BaseNumber)
            {
                return BaseNumber + InvokeStaticMethodResult;
            }

            #endregion

            #region Instance Methods

            public int InvokeInstanceMethod()
            {
                return InvokeStaticMethodResult;
            }

            public static int InvokeInstanceMethodWithParameter(int BaseNumber)
            {
                return BaseNumber + InvokeStaticMethodResult;
            }

            #endregion

            #region Static Generic Methods

            public static int InvokeStaticGenericMethodWithNoParameter<T>()
            {
                return InvokeStaticMethodResult;
            }

            public static int InvokeStaticGenericMethodWithParameters<T>(int BaseNumber)
            {
                return BaseNumber + InvokeStaticMethodResult;
            }

            public static int InvokeStaticGenericMethodWithGenericParameters<T>(int BaseNumber, IEnumerable<T> GenericParameter)
            {
                return BaseNumber + InvokeStaticMethodResult;
            }

            public static int InvokeStaticGenericMethodPassingInT<T>(int BaseNumber, T Item)
                where T : TestGenericClass
            {
                return BaseNumber + Item.Id;
            }

            #endregion

            #region Instance Generic Methods

            public int InvokeInstanceGenericMethodWithNoParameter<T>()
            {
                return InvokeStaticMethodResult;
            }

            public int InvokeInstanceGenericMethodWithParameters<T>(int BaseNumber)
            {
                return BaseNumber + InvokeStaticMethodResult;
            }

            public int InvokeInstanceGenericMethodWithGenericParameters<T>(int BaseNumber, IEnumerable<T> GenericParameter)
            {
                return BaseNumber + InvokeStaticMethodResult;
            }

            public int InvokeInstanceGenericMethodPassingInT<T>(int BaseNumber, T Item)
             where T : TestGenericClass
            {
                return BaseNumber + Item.Id;
            }

            #endregion

        }

        private class TestGenericClass
        {
            public int Id { get { return InvokeRegularMethod.InvokeStaticMethodResult; } }
        }

        #endregion

        #region Unit Tests

        #region Static Methods

        /// <summary>
        /// Invoke a static method with no parameters
        /// </summary>
        [Fact]
        public void InvokeRegularStaticMethodWithNoParametersTest1()
        {
            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult, new NonGenericStaticMethodFinder(typeof(InvokeRegularMethod), nameof(InvokeRegularMethod.InvokeStaticMethod), null).FindMethodToInvoke().Invoke(null, null));
        }

        /// <summary>
        /// Invoke a static method with parameters
        /// </summary>
        [Fact]
        public void InvokeRegularStaticMethodWithParametersTest1()
        {
            //number to pass in
            const int NumberToAdd = 10;

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new NonGenericStaticMethodFinder(typeof(InvokeRegularMethod), nameof(InvokeRegularMethod.InvokeStaticMethodWithParameter), new Type[] { typeof(int) }).FindMethodToInvoke().Invoke(null, new object[] { NumberToAdd }));
        }

        #endregion

        #region Instance Methods

        /// <summary>
        /// Invoke an instance method with no parameters
        /// </summary>
        [Fact]
        public void InvokeRegularInstanceMethodWithClassObjectAndNoParametersTest1()
        {
            //create the instance of the class
            var InstanceOfClass = new InvokeRegularMethod();

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult, new NonGenericInstanceMethodFinder(InstanceOfClass, nameof(InvokeRegularMethod.InvokeInstanceMethod), null).FindMethodToInvoke().Invoke(InstanceOfClass, null));
        }

        /// <summary>
        /// Invoke an instance method with parameters using the class object overload
        /// </summary>
        [Fact]
        public void InvokeRegularInstanceMethodWithClassObjectWithParametersTest1()
        {
            //number to pass in
            const int NumberToAdd = 10;

            //create the instance of the class
            var InstanceOfClass = new InvokeRegularMethod();

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new NonGenericInstanceMethodFinder(InstanceOfClass, nameof(InvokeRegularMethod.InvokeInstanceMethodWithParameter), new Type[] { typeof(int) }).FindMethodToInvoke().Invoke(InstanceOfClass, new object[] { NumberToAdd }));
        }

        #endregion

        #region Static Generic Methods

        /// <summary>
        /// Invoke a generic static method with no parameters
        /// </summary>
        [Fact]
        public void InvokeGenericRegularStaticMethodWithNoParametersTest1()
        {
            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult, new GenericStaticMethodFinder(typeof(InvokeRegularMethod), nameof(InvokeRegularMethod.InvokeStaticGenericMethodWithNoParameter), new Type[] { typeof(string) }, null).FindMethodToInvoke().Invoke(null, null));
        }

        /// <summary>
        /// Invoke a generic static method with parameters
        /// </summary>
        [Fact]
        public void InvokeGenericRegularStaticMethodWithParametersTest1()
        {
            //number to pass in
            const int NumberToAdd = 10;

            var Parameters = new List<GenericTypeParameter>
            {
                new GenericTypeParameter(typeof(int),false)
            };

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new GenericStaticMethodFinder(typeof(InvokeRegularMethod), nameof(InvokeRegularMethod.InvokeStaticGenericMethodWithParameters), new Type[] { typeof(string) }, Parameters).FindMethodToInvoke().Invoke(null, new object[] { NumberToAdd }));
        }

        /// <summary>
        /// Invoke a generic static method with parameters when the parameter is a generic type
        /// </summary>
        [Fact]
        public void InvokeGenericRegularStaticMethodWithParametersThatIsGenericTest1()
        {
            //number to pass in
            const int NumberToAdd = 10;

            var Parameters = new List<GenericTypeParameter>
            {
                new GenericTypeParameter(typeof(int),false),
                new GenericTypeParameter(typeof(IEnumerable<>), true)
            };

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new GenericStaticMethodFinder(typeof(InvokeRegularMethod), nameof(InvokeRegularMethod.InvokeStaticGenericMethodWithGenericParameters), new Type[] { typeof(string) }, Parameters).FindMethodToInvoke().Invoke(null, new object[] { NumberToAdd, new string[] { "Test1", "Test2" } }));
        }

        /// <summary>
        /// Invoke a generic static method where we pass in T as a parameter
        /// </summary>
        [Fact]
        public void InvokeGenericRegularStaticMethodWithPassingInTTest1()
        {
            //number to pass in
            const int NumberToAdd = 10;

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new GenericStaticMethodFinder(typeof(InvokeRegularMethod), nameof(InvokeRegularMethod.InvokeStaticGenericMethodPassingInT),
                new Type[]
                {
                    typeof(TestGenericClass)
                },
                new List<GenericTypeParameter>
                {
                    new GenericTypeParameter(typeof(int),false),
                    new GenericTypeParameter(typeof(TestGenericClass),true)
                }).FindMethodToInvoke().Invoke(null, new object[] { NumberToAdd, new TestGenericClass(), }));
        }

        #endregion

        #region Instance Generic Methods

        /// <summary>
        /// Invoke a generic instance method with no parameters
        /// </summary>
        [Fact]
        public void InvokeGenericRegularInstanceMethodWithNoParametersTest1()
        {
            //instance of the class that contains this method
            var InstanceOfObjectWithClass = new InvokeRegularMethod();

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult, new GenericInstanceMethodFinder(InstanceOfObjectWithClass, nameof(InvokeRegularMethod.InvokeInstanceGenericMethodWithNoParameter), new Type[] { typeof(string) }, null).FindMethodToInvoke().Invoke(InstanceOfObjectWithClass, null));
        }

        /// <summary>
        /// Invoke a generic instance method with parameters
        /// </summary>
        [Fact]
        public void InvokeGenericRegularInstanceMethodWithParametersTest1()
        {
            //instance of the class that contains this method
            var InstanceOfObjectWithClass = new InvokeRegularMethod();

            //number to pass in
            const int NumberToAdd = 10;

            var Parameters = new List<GenericTypeParameter>
            {
                new GenericTypeParameter(typeof(int),false)
            };

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new GenericInstanceMethodFinder(InstanceOfObjectWithClass, nameof(InvokeRegularMethod.InvokeInstanceGenericMethodWithParameters), new Type[] { typeof(string) }, Parameters).FindMethodToInvoke().Invoke(InstanceOfObjectWithClass, new object[] { NumberToAdd }));
        }

        /// <summary>
        /// Invoke a generic instance method with parameters when the parameter is a generic type
        /// </summary>
        [Fact]
        public void InvokeGenericRegularInstanceMethodWithParametersThatIsGenericTest1()
        {
            //instance of the class that contains this method
            var InstanceOfObjectWithClass = new InvokeRegularMethod();

            //number to pass in
            const int NumberToAdd = 10;

            var Parameters = new List<GenericTypeParameter>
            {
                new GenericTypeParameter(typeof(int),false),
                new GenericTypeParameter(typeof(IEnumerable<>), true)
            };

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new GenericInstanceMethodFinder(InstanceOfObjectWithClass, nameof(InvokeRegularMethod.InvokeInstanceGenericMethodWithGenericParameters), new Type[] { typeof(string) }, Parameters).FindMethodToInvoke().Invoke(InstanceOfObjectWithClass, new object[] { NumberToAdd, new string[] { "Test1", "Test2" } }));
        }

        /// <summary>
        /// Invoke a generic instance method where we pass in T as a parameter
        /// </summary>
        [Fact]
        public void InvokeGenericRegularInstanceMethodWithParametersInTGenericTest1()
        {
            //instance of the class that contains this method
            var InstanceOfObjectWithClass = new InvokeRegularMethod();

            //number to pass in
            const int NumberToAdd = 10;

            //let's go invoke this method dynamically (static method)
            Assert.Equal(InvokeRegularMethod.InvokeStaticMethodResult + NumberToAdd, new GenericInstanceMethodFinder(InstanceOfObjectWithClass, nameof(InvokeRegularMethod.InvokeInstanceGenericMethodPassingInT),
                new Type[]
                {
                    typeof(TestGenericClass)
                },
                new List<GenericTypeParameter>
                {
                    new GenericTypeParameter(typeof(int),false),
                    new GenericTypeParameter(typeof(TestGenericClass),true)
                }).FindMethodToInvoke().Invoke(InstanceOfObjectWithClass, new object[] { NumberToAdd, new TestGenericClass(), }));
        }

        #endregion

        #endregion

    }

}
