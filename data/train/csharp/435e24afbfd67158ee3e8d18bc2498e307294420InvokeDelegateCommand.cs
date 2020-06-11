using UnityEngine;
using System.Collections;

namespace BlurryRoots {
	namespace Commands {

		/// <summary>
		/// Callback type used by InvokeDelegateCommand.
		/// </summary>
		public delegate void InvokeDelegateCommandDelegate ();

		/// <summary>
		/// Command used to invoke an InvokeDelegateCommandDelegate.
		/// </summary>
		public class InvokeDelegateCommand : ICommand {

			/// <summary>
			/// Executes the command.
			/// </summary>
			public void Execute () {
				this.callback.Invoke ();
			}

			/// <summary>
			/// Creates a new InvokeDelegateCommand.
			/// </summary>
			/// <param name="callback">Callback to invoke on Execute.</param>
			public InvokeDelegateCommand (InvokeDelegateCommandDelegate callback) {
				this.callback = callback;
			}

			/// <summary>
			/// Callback to invoke.
			/// </summary>
			protected InvokeDelegateCommandDelegate callback;

		}

	}
}