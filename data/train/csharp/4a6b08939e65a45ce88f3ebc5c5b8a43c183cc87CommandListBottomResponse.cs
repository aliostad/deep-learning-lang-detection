using General.CIR.ViewModels;

namespace General.CIR.Commands.ScreenBtnResponse
{
	public class CommandListBottomResponse : BtnResponseBase
	{
		public override void ClickUp()
		{
			DispatchCommandViewModel dispatchCommandViewModel = ViewModel.DispatchCommandViewModel;
			int num = dispatchCommandViewModel.DisplayUnits.IndexOf(dispatchCommandViewModel.SelectUnit);
			bool flag = num < dispatchCommandViewModel.DisplayUnits.Count - 1;
			if (flag)
			{
				dispatchCommandViewModel.SelectUnit = dispatchCommandViewModel.DisplayUnits[num + 1];
			}
		}

		public override void ClickDown()
		{
		}
	}
}
