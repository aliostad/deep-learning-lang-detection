using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace PhotoHistory.API
{
	public class APIRegistration : AreaRegistration
	{
		public override string AreaName
		{
			get { return "API"; }
		}

		public override void RegisterArea(AreaRegistrationContext context)
		{
			context.MapRoute(
				"API test",
				"api/test",
				new { controller = "API_API", action = "Hello" } );

			context.MapRoute(
				"API verify credentials",
				"api/users/verify_credentials",
				new { controller = "API_Users", action = "VerifyCredentials" } );

			context.MapRoute(
				"API describe user",
				"api/users/{userName}",
				new { controller = "API_Users", action = "Describe" } );

			context.MapRoute(
				"API describe album",
				"api/albums/{id}",
				new { controller = "API_Albums", action = "Describe" } );

			context.MapRoute(
				"API describe photo",
				"api/photos/{id}",
				new { controller = "API_Photos", action = "Describe" } );

			context.MapRoute(
				"API upload photo",
				"api/photos",
				new { controller = "API_Photos", action = "UploadNew" } );

			context.MapRoute(
				"API 404 not found",
				"api/{*url}",
				new { controller = "API_API", action = "UnrecognizedCall" } );
		}
	}
}