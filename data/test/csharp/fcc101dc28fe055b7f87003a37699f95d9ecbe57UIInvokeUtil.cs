using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace KST
{
    /// <summary>
    /// 多线程UI界面控件访问及设置辅助类
    /// </summary>
    public class UIInvokeUtil
    {
        /// <summary>
        /// Invoke方式设置控件的Text属性
        /// </summary>
        public static void InvokeText(Control control, string text)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new MethodInvoker(delegate() { InvokeText(control, text); }));
            }
            else
            {
                control.Text = text;
            }
        }

        /// <summary>
        /// Invoke方式设置控件的ForeColor属性
        /// </summary>
        public static void InvokeForeColor(Control control, Color foreColor)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new MethodInvoker(delegate() { InvokeForeColor(control, foreColor); }));
            }
            else
            {
                control.ForeColor = foreColor;
            }
        }

        /// <summary>
        /// Invoke方式设置控件的Visible属性
        /// </summary>
        public static void InvokeVisible(Control control, bool isVisible)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new MethodInvoker(delegate() { InvokeVisible(control, isVisible); }));
            }
            else
            {
                control.Visible = isVisible;
            }
        }

        /// <summary>
        /// Invoke方式设置控件的Enabled属性
        /// </summary>
        public static void InvokeEnabled(Control control, bool isEnabled)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new MethodInvoker(delegate() { InvokeEnabled(control, isEnabled); }));
            }
            else
            {
                control.Enabled = isEnabled;
            }
        }

        /// <summary>
        /// Invoke方式设置控件的Tag属性
        /// </summary>
        public static void InvokeTag(Control control, object tag)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new MethodInvoker(delegate() { InvokeTag(control, tag); }));
            }
            else
            {
                control.Tag = tag;
            }
        }

        /// <summary>
        /// Invoke方式刷新控件
        /// </summary>
        public static void InvokeRefresh(Control control)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new MethodInvoker(delegate() { InvokeRefresh(control); }));
            }
            else
            {
                control.Refresh();
            }
        }

        /// <summary>
        /// Invoke方式设置ComboBox控件的SelectedIndex属性
        /// </summary>
        public static void InvokeComboxBoxSelectedIndex(ComboBox combox, int index)
        {
            if (combox.InvokeRequired)
            {
                combox.Invoke(new MethodInvoker(delegate() { InvokeComboxBoxSelectedIndex(combox, index); }));
            }
            else
            {
                combox.SelectedIndex = index;
            }
        }

        /// <summary>
        /// Invoke方式设置CheckBox控件的Checked属性
        /// </summary>
        public static void InvokeCheckBoxChecked(CheckBox checkbox, bool isChecked)
        {
            if (checkbox.InvokeRequired)
            {
                checkbox.Invoke(new MethodInvoker(delegate() { InvokeCheckBoxChecked(checkbox, isChecked); }));
            }
            else
            {
                checkbox.Checked = isChecked;
            }
        }

        /// <summary>
        /// Invoke方式设置RadioButton控件的Checked属性
        /// </summary>
        public static void InvokeRadioButtonChecked(RadioButton radioButton, bool isChecked)
        {
            if (radioButton.InvokeRequired)
            {
                radioButton.Invoke(new MethodInvoker(delegate() { InvokeRadioButtonChecked(radioButton, isChecked); }));
            }
            else
            {
                radioButton.Checked = isChecked;
            }
        }

        /// <summary>
        /// Invoke方式清空ListView控件的Items属性
        /// </summary>
        public static void InvokeClearListViewItems(ListView listView)
        {
            if (listView.InvokeRequired)
            {
                listView.Invoke(new MethodInvoker(delegate() { InvokeClearListViewItems(listView); }));
            }
            else
            {
                listView.Items.Clear();
            }
        }

        /// <summary>
        /// Invoke方式添加ListView控件的Item选项
        /// </summary>
        public static void InvokeAddListViewItems(ListView listView, ListViewItem item)
        {
            if (listView.InvokeRequired)
            {
                listView.Invoke(new MethodInvoker(delegate() { InvokeAddListViewItems(listView, item); }));
            }
            else
            {
                listView.Items.Add(item);
            }
        }

        /// <summary>
        /// Invoke方式设置DateTimePicker控件的Value属性
        /// </summary>
        public static void InvokeDateTimePickerValue(DateTimePicker dtp, DateTime dateTime)
        {
            if (dtp.InvokeRequired)
            {
                dtp.Invoke(new MethodInvoker(delegate() { InvokeDateTimePickerValue(dtp, dateTime); }));
            }
            else
            {
                dtp.Value = dateTime;
            }
        }

        /// <summary>
        /// Invoke方式设置窗体的TopMost属性
        /// </summary>
        public static void InvokeTopMost(Form form, bool isTopMost)
        {
            if (form.InvokeRequired)
            {
                form.Invoke(new MethodInvoker(() => { InvokeTopMost(form, isTopMost); }));
            }
            else
            {
                form.TopMost = isTopMost;
            }
        }

        /// <summary>
        /// Invoke方式添加TreeView的Node
        /// </summary>
        public static void InvokeAddNode(TreeView treeView, TreeNode node)
        {
            if (treeView.InvokeRequired)
            {
                treeView.Invoke(new MethodInvoker(() => { InvokeAddNode(treeView, node); }));
            }
            else
            {
                treeView.Nodes.Add(node);
            }
        }
    }
}
