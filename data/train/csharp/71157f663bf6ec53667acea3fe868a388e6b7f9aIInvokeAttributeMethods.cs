namespace SharpRemote.Test.Types.Interfaces
{
	public interface IInvokeAttributeMethods
	{
		void NoAttribute();

		[Invoke(Dispatch.DoNotSerialize)]
		void DoNotSerialize();

		[Invoke(Dispatch.SerializePerType)]
		void SerializePerType();

		[Invoke(Dispatch.SerializePerObject)]
		void SerializePerObject1();

		[Invoke(Dispatch.SerializePerObject)]
		void SerializePerObject2();

		[Invoke(Dispatch.SerializePerMethod)]
		void SerializePerMethod1();

		[Invoke(Dispatch.SerializePerMethod)]
		void SerializePerMethod2();
	}
}