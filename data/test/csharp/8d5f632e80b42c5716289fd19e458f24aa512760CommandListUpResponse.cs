using General.CIR.ViewModels;

namespace General.CIR.Commands.ScreenBtnResponse
{
	public class CommandListUpResponse : BtnResponseBase
	{
		public override void ClickUp()
		{
			DispatchCommandViewModel dispatchCommandViewModel = ViewModel.DispatchCommandViewModel;
			int num = dispatchCommandViewModel.DisplayUnits.IndexOf(dispatchCommandViewModel.SelectUnit);
			bool flag = num != 0;
			if (flag)
			{
				dispatchCommandViewModel.SelectUnit = dispatchCommandViewModel.DisplayUnits[num - 1];
			}
		}

		public override void ClickDown()
		{
		}
	}
}
