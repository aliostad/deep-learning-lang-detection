using System;
using System.Linq.Expressions;
using ExpressionComparer;
using InvokeInliner;
using NUnit.Framework;

namespace Tests
{
	[TestFixture]
    public class General
	{
		private static int TestFunction() => 5;
		[Test]
		public void TestSimple()
		{
			var iParam = Expression.Parameter(typeof(int), "i");

			// Invoke(i => (i + 1), 3)
			var input = Expression.Invoke(Expression.Lambda(Expression.Add(iParam, Expression.Constant(1)), iParam), Expression.Constant(3));

			// (3 + 1)
			var expected = Expression.Add(Expression.Constant(3), Expression.Constant(1));

			var actual = input.InlineInvokes();
			ExpressionEqualityComparer.AssertExpressionsEqual(expected, actual);
		}

		[Test]
		public void TestMultiple()
		{
			var i = Expression.Parameter(typeof(int), "i");
			
			//Invoke(ia => (ia + 1), i)
			var ia = Expression.Parameter(typeof(int), "ia");
			var firstInvoke = Expression.Invoke(
				Expression.Lambda(
					Expression.Add(
						ia,
						Expression.Constant(1)
					),
					ia
				),
				i
			);
			
			//Invoke(ib => (ib + 2), i)
			var ib = Expression.Parameter(typeof(int), "ib");
			var secondInvoke = Expression.Invoke(
				Expression.Lambda(
					Expression.Add(
						ib,
						Expression.Constant(2)
					),
					ib
				),
				i
			);

			var lExpr = Expression.Parameter(typeof(int), "lExpr");
			var rExpr = Expression.Parameter(typeof(int), "rExpr");
			// i => Invoke((lExpr, rExpr) => (lExpr * rExpr), Invoke(ia => (ia + 1), i), Invoke(ib => (ib + 2), i))
			var input =
				Expression.Lambda(
					Expression.Invoke(
						Expression.Lambda(
							Expression.Multiply(lExpr, rExpr),
							lExpr, rExpr
						),
						firstInvoke,
						secondInvoke
					),
					i);

			// i => ((i + 1) * (i + 2))
			var expected = Expression.Lambda(
				Expression.Multiply(
					Expression.Add(
						i,
						Expression.Constant(1)
					),
					Expression.Add(
						i,
						Expression.Constant(2)
					)
				), i);

			var actual = input.InlineInvokes();

			ExpressionEqualityComparer.AssertExpressionsEqual(expected, actual);
		}

		[Test]
		public void TestMultiple2()
		{
			var z = Expression.Parameter(typeof(int), "z");
			var h = Expression.Parameter(typeof(int), "h");
			var b = Expression.Parameter(typeof(int), "b");
			var c = Expression.Parameter(typeof(int), "c");
			var d = Expression.Parameter(typeof(int), "d");
			var e = Expression.Parameter(typeof(int), "e");

			// Invoke(h => (h * 8), z)
			var invokeA = Expression.Invoke(
				Expression.Lambda(
					Expression.Multiply(h, Expression.Constant(8)
					),
					h
				),
				z
			);

			// Invoke(z => (25 + Invoke(h => (h * 8), z)), b)
			var invokeB = Expression.Invoke(
				Expression.Lambda(
					Expression.Add(Expression.Constant(25), invokeA),
					z
				),
				b
			);

			//Invoke(b => (50 + Invoke(z => (25 + Invoke(h => (h * 8), z)), b)), b)
			var invokeC = Expression.Invoke(
				Expression.Lambda(
					Expression.Add(Expression.Constant(50), invokeB),
					b
				),
				b
			);

			// Invoke(c => (c + 2), b)
			var invokeD = Expression.Invoke(
				Expression.Lambda(
					Expression.Add(c, Expression.Constant(2)),
					c
				),
				b
			);

			// Invoke((d, e) => (d * e), Invoke(b => (50 + Invoke(z => (25 + Invoke(h => (h * 8), z)), b)), b), Invoke(c => (c + 2), b))
			var topInvoke = Expression.Invoke(
				Expression.Lambda(
					Expression.Multiply(d, e),
					d, e
				),
				invokeC, invokeD
			);

			// b => Invoke((d, e) => (d * e), Invoke(b => (50 + Invoke(z => (25 + Invoke(h => (h * 8), z)), b)), b), Invoke(c => (c + 2), b))
			var input = Expression.Lambda(
				topInvoke,
				b
			);
			var actual = input.InlineInvokes();

			// b => ((50 + (25 + (b * 8))) * (b + 2)) 
			var expected = Expression.Lambda(
				Expression.Multiply(
					Expression.Add(
						Expression.Constant(50),
						Expression.Add(
							Expression.Constant(25),
							Expression.Multiply(b, Expression.Constant(8))
						)
					),
					Expression.Add(b, Expression.Constant(2))
				),
				b
			);

			ExpressionEqualityComparer.AssertExpressionsEqual(expected, actual);
		}

		[Test]
	    public void TestConstantFunction()
	    {
			var expected = Expression.Invoke(Expression.Constant((Func<int>)TestFunction));
			var actual = Expression.Invoke(Expression.Constant((Func<int>)TestFunction)).InlineInvokes();

			ExpressionEqualityComparer.AssertExpressionsEqual(expected, actual);
	    }

		[Test]
		public void TestInnerInvokeReferencingAncestorParameter()
		{
			var expected = Expression.Add(Expression.Constant(1), Expression.Constant(2));

			var iParam = Expression.Parameter(typeof(int));
			var lParam = Expression.Parameter(typeof(int));

			var actual = Expression.Invoke(
				Expression.Lambda(
					Expression.Invoke(
							Expression.Lambda(
								Expression.Add(iParam, lParam),
								iParam),
							Expression.Constant(1)
					),
					lParam),
				Expression.Constant(2)
			).InlineInvokes();

			ExpressionEqualityComparer.AssertExpressionsEqual(expected, actual);
		}

		[Test]
		public void TestInnerInvokeOverridingAncestorParameter()
		{
			var expected = Expression.Add(Expression.Constant(1), Expression.Constant(3));

			var iParam = Expression.Parameter(typeof(int));
			var lParam = Expression.Parameter(typeof(int));

			var actual = Expression.Invoke(
				Expression.Lambda(
					Expression.Invoke(
						Expression.Lambda(
							Expression.Add(iParam, lParam),
							iParam, lParam),
						Expression.Constant(1), Expression.Constant(3)
					),
					lParam),
				Expression.Constant(2)
			).InlineInvokes();

			ExpressionEqualityComparer.AssertExpressionsEqual(expected, actual);
		}
	}
}
