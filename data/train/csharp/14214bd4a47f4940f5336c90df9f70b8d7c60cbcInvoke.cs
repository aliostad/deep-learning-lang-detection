using System;
using GodLesZ.Library.Amf.Messaging.Api;
using GodLesZ.Library.Amf.Messaging.Api.Service;
using GodLesZ.Library.Amf.Util;

namespace GodLesZ.Library.Amf.Messaging.Rtmp.Event {
	/// <summary>
	/// This type supports the infrastructure and is not intended to be used directly from your code.
	/// </summary>
	[CLSCompliant(false)]
	public class Invoke : Notify {
		internal Invoke() {
			_dataType = Constants.TypeInvoke;
		}

		internal Invoke(ByteBuffer data)
			: base(data) {
			_dataType = Constants.TypeInvoke;
		}

		internal Invoke(byte[] data)
			: base(data) {
			_dataType = Constants.TypeInvoke;
		}

		internal Invoke(IServiceCall serviceCall)
			: base(serviceCall) {
			_dataType = Constants.TypeInvoke;
		}
	}
}
