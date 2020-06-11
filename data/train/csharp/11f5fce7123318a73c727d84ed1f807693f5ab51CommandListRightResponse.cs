using General.CIR.ViewModels;

namespace General.CIR.Commands.ScreenBtnResponse
{
	public class CommandListRightResponse : BtnResponseBase
	{
		public override void ClickUp()
		{
			DispatchCommandViewModel dispatchCommandViewModel = ViewModel.DispatchCommandViewModel;
			int num = dispatchCommandViewModel.DisplayUnits.IndexOf(dispatchCommandViewModel.SelectUnit);
			bool flag = num + 10 < dispatchCommandViewModel.DisplayUnits.Count - 1;
			if (flag)
			{
				dispatchCommandViewModel.SelectUnit = dispatchCommandViewModel.DisplayUnits[num + 10];
			}
			else
			{
				dispatchCommandViewModel.SelectUnit = dispatchCommandViewModel.DisplayUnits[dispatchCommandViewModel.DisplayUnits.Count - 1];
			}
		}

		public override void ClickDown()
		{
		}
	}
}
