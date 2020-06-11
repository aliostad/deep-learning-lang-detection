using System;
using System.Collections.Generic;

namespace Lifetime
{
	public class RepositoryBasketDiscountPolicy : BasketDiscountPolicy
	{
		private readonly DiscountRepository repository;

		public RepositoryBasketDiscountPolicy(DiscountRepository repository)
		{
			if (repository == null)
			{
				throw new ArgumentNullException("repository");
			}

			this.repository = repository;
		}

		public DiscountRepository Repository
		{
			get { return this.repository; }
		}

		public override IEnumerable<Product> GetDiscountedProducts()
		{
			return this.repository.GetDiscountedProducts();
		}
	}
}