using University.DataObjects;

namespace UI.Process
{
	internal static class ProcessUtils
	{
		public static SalaryProcess CreateSalaryProcess(Entry entry)
		{
			SalaryProcess process = null;
			if (entry is Student)
			{
				process = new StudentSalaryProcess(new ProcessStudentSalaryDataObject());
			}
			if (entry is Lecturer)
			{
				process = new LecturerSalaryProcess(new ProcessLecturerSalaryDataObject());
			}
			if (process == null)
			{
				return null;
			}
			process.Id = entry.Id;
			process.DataType = entry.DataType;
			return process;
		}
	}
}