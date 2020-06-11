using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using General.CIR.Models.States;
using General.CIR.Models.Units;
using General.CIR.Resource;

namespace General.CIR.Commands.SerchItemResponse
{
	public class DispatchCommandResponse : CustomCommandBase
	{
		//[CompilerGenerated]
		//[Serializable]
		//private sealed class <>c
		//{
		//	public static readonly DispatchCommandResponse.<>c <>9 = new DispatchCommandResponse.<>c();

		//	public static Func<DispatchCommandUnit, bool> <>9__0_0;

		//	internal bool <CommandAction>b__0_0(DispatchCommandUnit w)
		//	{
		//		return w.CommandType == CommandType.DispatchCommand;
		//	}
		//}

		protected override void CommandAction()
		{
			IEnumerable<DispatchCommandUnit> collection = ViewModel.DispatchCommandViewModel.AllUnit.Where(w=>w.CommandType==CommandType.DispatchCommand);
			ViewModel.DispatchCommandViewModel.DisplayUnits = new ObservableCollection<DispatchCommandUnit>(collection);
			ViewModel.DispatchCommandViewModel.SelectUnit = ViewModel.DispatchCommandViewModel.DisplayUnits.FirstOrDefault<DispatchCommandUnit>();
			ViewModel.Controller.NavigatorToKey(BtnItemKeys.调度命令查询界面列表界面);
			ViewModel.DispatchCommandViewModel.Trips = InFoResource.设置主界面提示信息;
		}
	}
}
