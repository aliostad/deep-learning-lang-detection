using System;
using Rhino.Mocks;
using SevenDigital.Api.Schema.LockerEndpoint;
using SevenDigital.Api.Schema.ReleaseEndpoint;
using SevenDigital.Api.Schema.TrackEndpoint;
using SevenDigital.Api.Wrapper;
using SevenDigital.Api.Wrapper.Extensions;

namespace SevenDigital.ApiSupportLayer.TestData.StubApiWrapper
{
	public static class ApiWrapper
	{
		public static IFluentApi<Locker> StubbedApi(Locker stubbedLockerToReturn)
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<Locker>>();
			fluentApi.Stub(x => x.ForUser("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.WithPageNumber(0)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.WithPageSize(0)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Sort(LockerSortColumn.PurchaseDate, SortOrder.Descending)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Return(stubbedLockerToReturn);
			return fluentApi;
		}

		public static IFluentApi<Track> StubbedTrackApi()
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<Track>>();
			fluentApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.ForTrackId(0)).IgnoreArguments().Return(fluentApi);
			return fluentApi;
		}

		public static IFluentApi<Release> StubbedApi(Release toReturn)
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<Release>>();
			fluentApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.ForReleaseId(0)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Return(toReturn);
			return fluentApi;
		}

		public static IFluentApi<ReleaseTracks> StubbedApi(ReleaseTracks toReturn)
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<ReleaseTracks>>();
			fluentApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.WithParameter("", "")).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.ForReleaseId(0)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Return(toReturn);
			return fluentApi;
		}

		public static IFluentApi<T> StubbedTypedFluentApi<T>(T toReturn)
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<T>>();
			fluentApi.Stub(x => x.WithParameter(null, null)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Return(toReturn);
			return fluentApi;
		}

		public static IFluentApi<T> StubbedTypedFluentApiThrows<T>(Exception toThrow)
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<T>>();
			fluentApi.Stub(x => x.WithParameter(null, null)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Throw(toThrow);
			return fluentApi;
		}

		public static IFluentApi<T> StubbedTypedFluentApiWthUser<T>(T toReturn)
		{
			var fluentApi = MockRepository.GenerateStub<IFluentApi<T>>();
			fluentApi.Stub(x => x.ForUser(null, null)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.WithParameter(null, null)).IgnoreArguments().Return(fluentApi);
			fluentApi.Stub(x => x.Please()).Return(toReturn);
			return fluentApi;
		} 
	}

}