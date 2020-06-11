using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MCS.Library.Workflow.Engine;
using MCS.Library.Workflow.Descriptors;
using MCS.Library.Workflow.OA.Engine;
using MCS.Library.Principal;
using MCS.Library.OGUPermission;

namespace MCS.OA.DataObjects.Workflow
{
	/// <summary>
	/// IWfProcess的扩展
	/// </summary>
	public static class WfProcessExtension
	{
		/// <summary>
		/// 根据一个旧流程的定义，启动一个新的流程
		/// </summary>
		/// <param name="originalProcess"></param>
		/// <param name="newResourceID"></param>
		/// <returns></returns>
		public static IWfProcess StartClonedProcess(this IWfProcess originalProcess, string newResourceID)
		{
			IWfProcessDescriptor newProcessDesp =
					originalProcess.FirstActivity.Descriptor.Process.GenerateNewProcessDescriptor();

			IWfProcess newProcess = StartNewProcess(newProcessDesp,
					originalProcess,
					newResourceID,
					originalProcess.FirstActivity != null ? originalProcess.FirstActivity.Operator : DeluxeIdentity.CurrentUser,
					originalProcess.OwnerDepartment);

			return newProcess;
		}

		private static IWfProcess StartNewProcess(IWfProcessDescriptor processDesp, IWfProcess originalProcess, string newResourceID, IUser processCreator, IOrganization department)
		{
			WfProcessStartupParams wp =
					new WfProcessStartupParams(processDesp);

			IWfProcess process = WfRuntime.StartWorkflow(typeof(OAWfProcess), wp);

			process.OwnerDepartment = department;
			WfTransferParams tParams = new WfTransferParams(wp.Descriptor.InitialActivity);

			tParams.Operator = DeluxeIdentity.CurrentUser;

			tParams.Receivers.Add(processCreator);

			process.MoveTo(tParams);

			process.Context["ApplicationName"] = originalProcess.Context["ApplicationName"];
			process.Context["ProgramName"] = originalProcess.Context["ProgramName"];

			((OAWfProcess)process).ResourceID = newResourceID;
			process.Context[WfVariableDefine.ProcessDraftDepartmentNameVariableName] =
				WfVariableDefine.GetProcessDraftDepartmentName(originalProcess);

			process.Context[WfVariableDefine.ProcessDraftUserIDVariableName] =
				WfVariableDefine.GetProcessDraftUserID(originalProcess);

			process.Context[WfVariableDefine.ProcessDraftUserNameVariableName] =
				WfVariableDefine.GetProcessDraftUserName(originalProcess);

			return process;
		}
	}
}
