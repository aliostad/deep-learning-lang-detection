using System.Collections.ObjectModel;
using System.Linq;
using General.CIR.Models.Units;
using General.CIR.Resource;

namespace General.CIR.Commands.SerchItemResponse
{
	public class AllDispatchCommandResponse : CustomCommandBase
	{
		protected override void CommandAction()
		{
			ObservableCollection<DispatchCommandUnit> allUnit = ViewModel.DispatchCommandViewModel.AllUnit;
			ViewModel.DispatchCommandViewModel.DisplayUnits = new ObservableCollection<DispatchCommandUnit>(allUnit);
			ViewModel.DispatchCommandViewModel.SelectUnit = ViewModel.DispatchCommandViewModel.DisplayUnits.FirstOrDefault<DispatchCommandUnit>();
			ViewModel.Controller.NavigatorToKey(BtnItemKeys.调度命令查询界面列表界面);
			ViewModel.DispatchCommandViewModel.Trips = InFoResource.设置主界面提示信息;
		}
	}
}
