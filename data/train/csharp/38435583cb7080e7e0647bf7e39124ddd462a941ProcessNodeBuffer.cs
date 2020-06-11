using System.Windows.Forms;
using WFProcessReader.Entities;

namespace WFProcessReader.Controls
{
	internal sealed class ProcessNodeBuffer
	{
		public string Pid { get { return Process?.Pid; } }

		public TreeNode Node { get; set; }

		public Process Process { get; set; }

		public static ProcessNodeBuffer Create(Process process)
		{
			if (process == null)
				return null;

			var node = new ExtendedTreeNode($"({process.TotalDuration.ToString()}) {process.Code} ({process.Pid})");
			node.Tag = process.Pid;

			return new ProcessNodeBuffer
			{
				Node = node,
				Process = process,
			};
		}
	}
}
