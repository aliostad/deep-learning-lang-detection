/* start Loader.cs */

using System;
using System.Collections.Generic;

namespace io.newgrounds.results.Loader {

	/// <summary>
	/// Contains results for calls to 'Loader'
	/// </summary>
	public class loadAuthorUrl : LoaderResult 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type loadAuthorUrl 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<loadAuthorUrl>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'Loader'
	/// </summary>
	public class loadMoreGames : LoaderResult 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type loadMoreGames 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<loadMoreGames>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'Loader'
	/// </summary>
	public class loadNewgrounds : LoaderResult 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type loadNewgrounds 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<loadNewgrounds>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'Loader'
	/// </summary>
	public class loadOfficialUrl : LoaderResult 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type loadOfficialUrl 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<loadOfficialUrl>(component, this);
		}
	}
	

	/// <summary>
	/// Contains results for calls to 'Loader'
	/// </summary>
	public class loadReferral : LoaderResult 
	{

		/// <summary>
		/// overrides default dispatchMe behaviour to dispatch as Type loadReferral 
		/// </summary>
		public override void dispatchMe(string component)
		{
			ngio_core.dispatchEvent<loadReferral>(component, this);
		}
	}
	
}

/* end Loader.cs */

