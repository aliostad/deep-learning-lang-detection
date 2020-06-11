using System.Collections.Generic;
using NUnit.Framework;
using Rhino.Mocks;
using SevenDigital.Api.Schema.Premium.User;
using SevenDigital.Api.Wrapper;
using SevenDigital.ApiSupportLayer.User;

namespace SevenDigital.ApiSupportLayer.Unit.Tests.User
{
	[TestFixture]
	public class UserApiTests
	{
		[Test]
		public void User_does_not_exist()
		{
			var fluentApi = UserApiThatReturnsNoUsers();

			var userSignupApi = MockRepository.GenerateStub<IFluentApi<UserSignup>>();
			var userApi = new UserApi(fluentApi, userSignupApi);

			var checkUserExists = userApi.CheckUserExists("test@test.com");

			Assert.That(checkUserExists, Is.False);
		}

		[Test]
		public void User_exists()
		{
			var fluentApi = UserApiThatReturnsUser("test@test.com");

			var userSignupApi = MockRepository.GenerateStub<IFluentApi<UserSignup>>();
			var userApi = new UserApi(fluentApi, userSignupApi);

			var checkUserExists = userApi.CheckUserExists("test@test.com");

			Assert.That(checkUserExists);
		}

		[Test]
		public void Doesn_not_pass_affiliate_partner_if_not_specified()
		{
			var fluentApi = UserApiThatReturnsUser("test@test.com");

			var userSignupApi = MockRepository.GenerateStub<IFluentApi<UserSignup>>();
			userSignupApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(userSignupApi);

			var userApi = new UserApi(fluentApi, userSignupApi);

			userApi.Create("emailAddress", "password");

			userSignupApi.AssertWasNotCalled(x=>x.WithParameter(Arg<string>.Is.Equal("affiliatePartner"), Arg<string>.Is.Anything));
		}

		[Test]
		public void Passes_the_affililate_partner_if_specified()
		{
			var fluentApi = UserApiThatReturnsUser("test@test.com");

			var userSignupApi = MockRepository.GenerateStub<IFluentApi<UserSignup>>();
			userSignupApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(userSignupApi);

			var userApi = new UserApi(fluentApi, userSignupApi);

			userApi.Create("emailAddress", "password", "boo");

			userSignupApi.AssertWasCalled(x => x.WithParameter("affiliatePartner","boo"));
		}

		private static IFluentApi<Users> UserApiThatReturnsNoUsers()
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<Users>>();
			fluentApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Return(new Users()
			{
				UserList = new List<Api.Schema.Premium.User.User>()
			});
			return fluentApi;
		}

		private static IFluentApi<Users> UserApiThatReturnsUser(string emailAddress)
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<Users>>();
			fluentApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Return(new Users()
			{
				UserList = new List<Api.Schema.Premium.User.User>() { new Api.Schema.Premium.User.User() { EmailAddress = emailAddress, Id=emailAddress, Type="Test"} }
			});
			return fluentApi;
		}
	}
}
