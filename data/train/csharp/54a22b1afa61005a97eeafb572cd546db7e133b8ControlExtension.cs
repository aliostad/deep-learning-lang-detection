using System;
using System.Windows.Forms;

namespace YunDa.JC.MMI.Common.Extensions
{
   public static class ControlExtension
    {
       public static void InvokeIfNeed(this Control control, Delegate methed, params object[] objs)
       {
           if (control.InvokeRequired)
           {
               control.Invoke(methed, objs);
               
           }
           else
           {
               methed.DynamicInvoke(objs);
           }
       }

       private static readonly Action<Control> InvalidateAction = t => t.Invalidate();

       public static void InvokeInvalidate(this Control control)
       {
           if (control.InvokeRequired)
           {
               control.Invoke(InvalidateAction, control);
           }
           else
           {
               InvalidateAction.DynamicInvoke(control);
           }
       }

       private static readonly Action<Control, bool> VisibleAction = (t, b) => t.Visible = b;

       public static void InvokeVisible(this Control control, bool visible)
       {
           if (control.InvokeRequired)
           {
               control.Invoke(VisibleAction,control, visible);
           }
           else
           {
               VisibleAction.DynamicInvoke(control, visible);
           }
       }

       private static readonly Action<Control> ShowAction = (t) => t.Show();

       public static void InvokeShow(this Control control)
       {
           if (control.InvokeRequired)
           {
               //ShowAction(control);
               control.Invoke(ShowAction, control);
           }
           else
           {
               ShowAction.DynamicInvoke(control);
           }
       }

       private static readonly Action<Control> HideAction = (t) => t.Hide();

       public static void InvokeHide(this Control control)
       {
           if (control.InvokeRequired)
           {
               //HideAction(control);
               control.Invoke(HideAction, control);
           }
           else
           {
               HideAction.DynamicInvoke(control);
           }
       }


       private static readonly Action<Control, Control> RemoveChildAction = (t, b) => t.Controls.Remove(b);

       public static void InvokeRemoveChild(this Control control, Control visible)
       {
           if (control.InvokeRequired)
           {
               control.Invoke(RemoveChildAction, control, visible);
           }
           else
           {
               RemoveChildAction.DynamicInvoke(control, visible);
           }
       }

       private static readonly Action<Control, Control> AddChildAction = (t, b) => t.Controls.Add(b);

       public static void InvokeAddChild(this Control control, Control visible)
       {
           if (control.InvokeRequired)
           {
               control.Invoke(AddChildAction, control, visible);
           }
           else
           {
               AddChildAction.DynamicInvoke(control, visible);
           }
       }
    }
}
