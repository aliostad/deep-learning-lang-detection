using System;
using System.ComponentModel.Composition;
using System.Text;
using CommonUtil.Util;
using General.CIR.CIRData;
using General.CIR.Commands.ScreenBtnResponse;
using General.CIR.Events;
using General.CIR.Extentions;
using General.CIR.Models.States;
using General.CIR.Models.Units;
using General.CIR.Resource;
using General.CIR.ViewModels;
using Microsoft.Practices.Prism.Events;
using Microsoft.Practices.ServiceLocation;

namespace General.CIR.Controller.ViewModelController
{
	[Export]
	public class DispatchCommandController : ControllerBase<DispatchCommandViewModel>
	{
		public DispatchCommandController()
		{
			EventAggregator.GetEvent<NetWorkDataEvent>().Subscribe(CommandResponse, ThreadOption.UIThread);
		}

		private void CommandResponse(NetWorkEventArgs obj)
		{
			CIRViewModel instance = ServiceLocator.Current.GetInstance<CIRViewModel>();
			bool flag = obj.BusinessType == BusinessType.Command;
			if (flag)
			{
				DispatchInfo dispatchInfo = (DispatchInfo)CIRCommAgent.BytesToStruct(obj.Data.Buff, typeof(DispatchInfo), 0);
				DispatchCommandUnit dispatchCommandUnit = new DispatchCommandUnit(dispatchInfo);
				bool flag2 = 31 >= dispatchInfo.cmdType && dispatchInfo.cmdType >= 24;
				if (flag2)
				{
					dispatchCommandUnit.CommandType = CommandType.OtherInfo;
				}
				else
				{
					dispatchCommandUnit.CommandType = (CommandType)dispatchInfo.cmdType;
				}
				dispatchCommandUnit.TrainNumber = dispatchInfo.TrainNum;
				dispatchCommandUnit.EngineNumber = dispatchInfo.TrainID.ToStrNumber();
				dispatchCommandUnit.ReleaseTime = dispatchInfo.DispatchDateTime;
				dispatchCommandUnit.ReleasePlace = dispatchInfo.SendDispatchCmdName;
				dispatchCommandUnit.ReleaseName = dispatchInfo.Dispatcher;
				dispatchCommandUnit.CommandName = dispatchInfo.DispatchCmdName;
				dispatchCommandUnit.Number = dispatchInfo.CmdNum;
				dispatchCommandUnit.Current = (instance.MainContentViewModel.SystemInfosViewModel.IsSupplyOrder ? "本" : "补");
				dispatchCommandUnit.Content = GetContent(dispatchInfo.DispatchCmdContext, instance.MainContentViewModel.SystemInfosViewModel.KMMark);
				ViewModel.AllUnit.Add(dispatchCommandUnit);
				ViewModel.DisplayUnit = dispatchCommandUnit;
				BtnResponseBase.OperateTime = DateTime.Now;
				instance.Controller.NavigatorToKey(BtnItemKeys.调度命令详细界面);
				CIRPacket cIRPacket = default(CIRPacket);
				cIRPacket.Init();
				cIRPacket.SetHeadInfo(1, 35, 6, 81);
				DispatchInfoSignConfirm dispatchInfoSignConfirm = default(DispatchInfoSignConfirm);
				dispatchInfoSignConfirm.Init();
				dispatchInfoSignConfirm.InfoName = 129;
				dispatchInfoSignConfirm.cmdForm = dispatchInfo.cmdForm;
				dispatchInfoSignConfirm.TrainID = dispatchInfo.TrainID;
				dispatchInfoSignConfirm.TrainNum = dispatchInfo.TrainNum;
				dispatchInfoSignConfirm.CmdNum = dispatchInfo.CmdNum;
				cIRPacket.SetData(CIRCommAgent.StructToBytes(dispatchInfoSignConfirm));
				AppLog.Info("自动确认收到调度命令pack1.GetPackLen()：{0}", new object[]
				{
					cIRPacket.GetPackLen()
				});
				CIRCommAgent.SendCIRData(CIRCommAgent.StructToBytes(cIRPacket), cIRPacket.GetDataLen(), false, 0);
			}
		}

		private string GetContent(string str, double kmMark)
		{
			StringBuilder stringBuilder = new StringBuilder(str);
			stringBuilder.Append("\r\n\r\n");
			stringBuilder.Append("接收时间：");
			stringBuilder.AppendLine(DateTime.Now.ToString("hh时mm分ss秒"));
			stringBuilder.AppendLine(string.Format("接受地点：公里标{0:F1}", kmMark));
			return stringBuilder.ToString();
		}

		private string GetReleasePlace(byte values)
		{
			return values.ToString();
		}
	}
}
