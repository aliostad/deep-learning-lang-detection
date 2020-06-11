using System;

namespace VitaUnit {

	public class MockTestMethod : ITestMethod {
		public bool WasInvokeCalled { get; private set; }

		public void Invoke(object instance) {
			WasInvokeCalled = true;
			
			if(OnInvoke != null)
				OnInvoke(this, EventArgs.Empty);
		}

		public bool IsUIThreadTest {
			get;
			set;
		}
		
		public bool Ignore { get; set; }

		private string _name = string.Empty;

		public string Name {
			get { return _name; }
			set { _name = value; }
		}
		
		public event EventHandler OnInvoke;
		
		public void Reset() {
			WasInvokeCalled = false;
		}
	}
}

