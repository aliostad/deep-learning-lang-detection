using System;
using System.Windows.Forms;

namespace InfinniPlatform.MetadataDesigner.Views.Status
{
	public partial class StatusForm : Form
	{
		private Action _actionToInvoke;

		public StatusForm()
		{
			this.HandleCreated += StatusForm_HandleCreated;
			InitializeComponent();

		}

		void StatusForm_HandleCreated(object sender, EventArgs e)
		{
			FormHandleCreated = true;
			if (ActionToInvoke != null)
			{
				this.Invoke(ActionToInvoke);
			}
		}

		protected bool FormHandleCreated { get; set; }

		public Action ActionToInvoke
		{
			get { return _actionToInvoke; }
			set
			{

				if (FormHandleCreated)
				{
					this.Invoke(value);
					_actionToInvoke = null;
				}
				else
				{
					_actionToInvoke = value;
				}
			}
		}
	}
}
