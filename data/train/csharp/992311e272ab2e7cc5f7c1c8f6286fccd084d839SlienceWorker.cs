using ServiceStationClient.ComponentUI;
using ServiceStationClient.ComponentUI.TextBox;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace HXCPcClient
{

    /// <summary>
    /// 跨线程使用类
    /// </summary>
   public class SlienceWorker
    {
        #region 方法重载
        public static void CrossThreadInvoke(TextChooser t, MethodInvoker m)
        {
            if (t.InvokeRequired)
            {
                t.Invoke(m);
            }
        }
        public static void CrossThreadInvoke(TextBoxEx t, MethodInvoker m)
        {
            if (t.InvokeRequired)
            {
                t.Invoke(m);
            }
        }
        public static void CrossThreadInvoke(ComboBoxEx t, MethodInvoker m)
        {
            if (t.InvokeRequired)
            {
                t.Invoke(m);
            }
        }
        #endregion
    }
}
