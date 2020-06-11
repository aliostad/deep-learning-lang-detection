using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using CatWalk.Mvvm;

namespace CatWalk.Heron.ViewModel {
	public class AppViewModelBase : SynchronizeViewModel{
		public AppViewModelBase() : base(GetSynchronizeInvoke()){}

		public AppViewModelBase(ISynchronizeInvoke invoke)
			: base(invoke) {

		}

		private static ISynchronizeInvoke GetSynchronizeInvoke() {
			if(Application.Current != null) {
				return Application.Current.SynchronizeInvoke;
			} else {
				return new DefaultSynchronizeInvoke();
			}
		}
	}
}
