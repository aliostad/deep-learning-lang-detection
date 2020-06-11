namespace uFAction
{
	public interface IInvokableWithNoReturn
	{
		void Invoke();
	}
	public interface IInvokableWithNoReturn<TArg>
	{
		void Invoke(TArg arg);
	}
	public interface IInvokableWithNoReturn<TArg1, TArg2>
	{
		void Invoke(TArg1 arg1, TArg2 arg2);
	}
	public interface IInvokableWithNoReturn<TArg1, TArg2, TArg3>
	{
		void Invoke(TArg1 arg1, TArg2 arg2, TArg3 arg3);
	}
	public interface IInvokableWithReturn<TReturn>
	{
		TReturn Invoke();
	}
	public interface IInvokableWithReturn<TArg, TReturn>
	{
		TReturn Invoke(TArg arg);
	}
	public interface IInvokableWithReturn<TArg1, TArg2, TReturn>
	{
		TReturn Invoke(TArg1 arg1, TArg2 arg2);
	}
	public interface IInvokableWithReturn<TArg1, TArg2, TArg3, TReturn>
	{
		TReturn Invoke(TArg1 arg1, TArg2 arg2, TArg3 arg3);
	}
	public interface IInvokableFromEditor
	{
		void InvokeWithEditorArgs();
	}
}