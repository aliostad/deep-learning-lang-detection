using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace piBucket {
	static class generableField {
		public static apiValue create(apiObject apiNode, string name, apiValue initialValue) {
			apiNode.addProperty("name", name);
			apiNode.addProperty("type", initialValue.data.type.ToString());
			return apiNode.addProperty("value", initialValue) as apiValue;		
		}	

		public static apiValue create(apiObject apiNode, string name, string[] possibleValues) {
			apiNode.addProperty("name", name);
			apiNode.addProperty("type", "select");
			apiNode.addProperty("options", new apiArray(possibleValues));
			return apiNode.addProperty("value", new apiValue(possibleValues[0])) as apiValue;		
		}	
	}

}
