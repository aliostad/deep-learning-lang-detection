using General.CIR.ViewModels;

namespace General.CIR.Commands.ScreenBtnResponse
{
	public class CommandListLeftResponse : BtnResponseBase
	{
		public override void ClickUp()
		{
			DispatchCommandViewModel dispatchCommandViewModel = ViewModel.DispatchCommandViewModel;
			bool flag = dispatchCommandViewModel.DisplayUnits.Count == 0;
			if (!flag)
			{
				int num = dispatchCommandViewModel.DisplayUnits.IndexOf(dispatchCommandViewModel.SelectUnit);
				bool flag2 = num - 10 >= 0;
				if (flag2)
				{
					dispatchCommandViewModel.SelectUnit = dispatchCommandViewModel.DisplayUnits[num - 10];
				}
				else
				{
					dispatchCommandViewModel.SelectUnit = dispatchCommandViewModel.DisplayUnits[0];
				}
			}
		}

		public override void ClickDown()
		{
		}
	}
}
