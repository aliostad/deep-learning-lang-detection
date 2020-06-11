/* start App.cs */

using System;
using System.Collections.Generic;

namespace io.newgrounds.results.App {

	/// <summary>
	/// Contains results for calls to 'App'
	/// </summary>
	public class checkSession : SessionResult 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type checkSession 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<checkSession>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'App'
	/// </summary>
	public class endSession : ResultModel 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type endSession 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<endSession>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'App'
	/// </summary>
	public class getCurrentVersion : ResultModel 
	{

		/// <summary>
		/// Notes whether the client-side app is using a lower version number.
		/// </summary>
		public bool client_deprecated { get; set; }
		/// <summary>
		/// The version number of the app as defined in your "Version Control" settings.
		/// </summary>
		public string current_version { get; set; }
		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type getCurrentVersion 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<getCurrentVersion>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'App'
	/// </summary>
	public class getHostLicense : ResultModel 
	{

		/// <summary>
		/// Property 'host_approved'
		/// </summary>
		public bool host_approved { get; set; }
		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type getHostLicense 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<getHostLicense>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'App'
	/// </summary>
	public class logView : ResultModel 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type logView 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<logView>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'App'
	/// </summary>
	public class startSession : SessionResult 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type startSession 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<startSession>(component, this);
		}
	}
	
}

/* end App.cs */

