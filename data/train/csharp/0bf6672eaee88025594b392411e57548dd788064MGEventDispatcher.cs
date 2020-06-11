using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using UnityEngine;

public class MGEventDispatcher
{
	static MGEventDispatcher instance;

	public static MGEventDispatcher Instance(){
		if(instance != null){
			instance = new MGEventDispatcher();
		}

		return instance;
	}

    private Dictionary<int, List<DispatchEventHandler> > EventTable;

    //声明委托
    public delegate void DispatchEventHandler(System.Object sender, DispatchEventArgs e);
    //声明事件
    public event DispatchEventHandler Dispatch;

	public MGEventDispatcher()
    {
        EventTable = new Dictionary<int, List<DispatchEventHandler>>();
    }

    public void ClearAllEvent()
    {
        EventTable = new Dictionary<int, List<DispatchEventHandler>>();
    }

    public void dispacthEvent(int type)
    {
        if (EventTable.ContainsKey(type))
        {
            DispatchEventArgs e = new DispatchEventArgs();
            List<DispatchEventHandler> funcArr = (List<DispatchEventHandler>)EventTable[type];
            List<DispatchEventHandler> funcArrTemp = new List<DispatchEventHandler>(funcArr);
            foreach (DispatchEventHandler func in funcArrTemp)
            {
                this.Dispatch = func;
                OnDispatch(e);
            }
        }
    }
    public void dispacthEvent(int type, params object[] data)
    {
        if (EventTable.ContainsKey(type))
        {
            DispatchEventArgs e = new DispatchEventArgs(type, data);
            List<DispatchEventHandler> funcArr = (List<DispatchEventHandler>)EventTable[type];
            List<DispatchEventHandler> funcArrTemp = new List<DispatchEventHandler>(funcArr);
            foreach (DispatchEventHandler func in funcArrTemp)
            {
                this.Dispatch = func;
                OnDispatch(e);
            }
        }
    }

    // 可以供继承的类重写，以便继承类拒绝其他对象对它的监视
    protected virtual void OnDispatch(DispatchEventArgs e)
    {
        if (Dispatch != null)// 如果有对象注册
        {
            Dispatch(this, e);  // 调用所有注册对象的方法
        }
    }

    /// <summary>
    /// func回调方法格式:(Object obj, DispatchEventArgs e)
    /// </summary>
    /// <param name="type"></param>
    /// <param name="func"></param>
    public void addEventListener(int type, DispatchEventHandler func)
    {
        if (!EventTable.ContainsKey(type))
        {
            List<DispatchEventHandler> FuncList = new List<DispatchEventHandler>();
            FuncList.Add(func);
            EventTable.Add(type, FuncList);
        }
        else
        {
            List<DispatchEventHandler> funclist = (List<DispatchEventHandler>)EventTable[type];
            funclist.Add(func);
        }
    }

    public void removeEventListener(int type)
    {
        if (EventTable.ContainsKey(type))
        {
            EventTable.Remove(type);
        }
    }
    public void removeEventListener(int type, DispatchEventHandler func)
    {
        if (EventTable.ContainsKey(type))
        {
            List<DispatchEventHandler> funclist = (List<DispatchEventHandler>)EventTable[type];
            if (funclist.Contains(func))
            {
                funclist.Remove(func);
            }
            if (funclist.Count == 0)
            {
                EventTable.Remove(type);
            }
        }
    }

}
