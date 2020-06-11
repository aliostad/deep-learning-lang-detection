using System;

namespace cake.Tests
{
	class SimpleAction : ITargetGeneratingAction
	{
		private readonly Action<TargetGenerateSettings> _invoke;
		private readonly string _actionHash;

		public SimpleAction(Action<TargetGenerateSettings> invoke)
			: this(invoke,"defaulthash")
		{
		}

		public SimpleAction(Action<TargetGenerateSettings> invoke, string actionHash)
		{
			_invoke = invoke;
			_actionHash = actionHash;
		}

		public SimpleAction() : this(s=> { })
		{
		}

		public void Invoke(TargetGenerateSettings settings)
		{
			_invoke(settings);
		}

		public string GetActionHash()
		{
			return _actionHash;
		}
	}
}