using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PR.Presentation.TargetClient
{
    internal static class ControlExtensions
    {
        public static void InvokeControl<TControl>(this TControl control, Action<TControl> action)
            where TControl : Control
        {
            if (control.InvokeRequired)
            {
                control.Invoke((Action)(() => InvokeControl(control, action)));
            }
            else
            {
                action?.Invoke(control);
            }
        }
    }
}
