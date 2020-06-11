using System;
using Moq;
using TestBaseGenerator.Repository;

namespace TestBaseGenerator.Tests
{
	public abstract class GivenADepartmentRepository : SpecificationBase
	{
		protected DepartmentRepository DepartmentRepository;
		protected Mock<ProductRepository> MockProductRepository = new Mock<ProductRepository>();
		protected Mock<UserRepository> MockUserRepository = new Mock<UserRepository>();

		protected GivenADepartmentRepository()
		{
			DepartmentRepository = new DepartmentRepository(
				MockProductRepository.Object,
				MockUserRepository.Object);
		}
	}

	public abstract class GivenAProductRepository : SpecificationBase
	{
		protected ProductRepository ProductRepository;

		protected GivenAProductRepository()
		{
			ProductRepository = new ProductRepository();
		}
	}

	public abstract class GivenAnUserRepository : SpecificationBase
	{
		protected UserRepository UserRepository;

		protected GivenAnUserRepository()
		{
			UserRepository = new UserRepository();
		}
	}

}