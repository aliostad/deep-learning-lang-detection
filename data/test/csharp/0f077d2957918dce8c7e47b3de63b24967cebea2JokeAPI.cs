using UnityEngine;
using System.Collections;

namespace EB.Sparx 
{
	public class JokeAPI 
	{
		EndPoint _api;

		public JokeAPI( EndPoint api )
		{
			_api = api;
		}

		public void RequestJoke(Action<string, Hashtable> callback )
		{
			//_api.Service (_api.Get ("/joke"), delegate(Response result) {
			_api.Service (_api.Get ("/test"), delegate(Response result) {
				if(result.sucessful) 
				{
					callback(null, result.hashtable);
				}
				else 
				{
					callback(result.localizedError, null);
				}
			});
		}
	}
}