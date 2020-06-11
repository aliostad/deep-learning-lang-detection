using System;
namespace WorkoutDemo.Core
{
	public static class ApiConstants
	{
		public const int MaxRetryTime = 2;
	}

	public static class ApiUrls
	{
		public const string Root = "http://azing.azurewebsites.net";

		public const string ApiV1 = Root + "/v1";
		public const string Api = Root + "/api";
		public const string ApiToken = Root + "/token";
		public const string Register = Api + "/Account/Register";
		public const string User = Root + "/v1/user/api/user";
		public const string GetActivites = ApiV1 + "/activity/api/feed/list";
		public const string OwnerEvent = ApiV1 + "/event/api/owner/eventlist/";
		public const string OwnerEventDetails = ApiV1 + "/event/api/owner/event/";
		public const string EventSender = ApiV1 + "/event/api/sender/event";
		public const string DeleteActivity = ApiV1 + "/activity/api/feed/";
		public const string DeleteEvent = ApiV1 + "/activity/api/activity/";
		public const string Message = ApiV1 + "/message/api/message/list";
		public const string MySplash = ApiV1 + "/splash/api/tile/top";
		public const string GetComment = ApiV1 + "/comment/api/set/";
		public const string DeleteMessage = ApiV1 + "/message/api/message/";
		public const string PostComment = ApiV1 + "/comment/api/post/tile";
		public const string GetHomeStatus = ApiV1 + "/construction/api/home/status";
		public const string DeleteComment = ApiV1 + "/comment/api/comment/";
		public const string GetPersonList = ApiV1 + "/home/api/sites/builder/user/correspondents";
		public const string PostSplash = ApiV1 + "/splash/api/tile/post";
		public const string PostDeviceId = ApiV1 + "/user/api/device/set";
		public const string GetHomeTimeline = ApiV1 + "/construction/api/home/status/timeline";
		public const string UpdateProfile = ApiV1 + "/user/api/user/set/profile";
		public const string PostNewEvent = ApiV1 + "/event/api/sender/event/post";
		public const string PostMessage = ApiV1 + "/message/api/message/post";
		public const string ConfirmAccept = ApiV1 + "/event/api/event/acceptances";
		public const string GetHomeOwnerId = ApiV1 + "/home/api/sites/homeowner/correspondents";
		public const string EditSplash = ApiV1 + "/splash/api/tile/set";
	}
}
