using UnityEngine;
using System.Collections;
using TFramework.Base;

/// <summary>
///
/// 流程基类
/// 
/// 1 流程进行各流程间的切换
/// 2 当前流程内的关键事件方法仓库
///
/// </summary>
public class ProcessBase
{
    //流程控制
    protected ProcessManagerBase _nowProcessManager = null;

    //流程名称
    public string _nowProcessName = string.Empty;
    //流程的挂点
    protected GameObject _processPoint = null;

    //初始化
    public virtual void Initialization(ProcessManagerBase pm, GameObject processPoint)
    {
        _nowProcessManager = pm;
        _processPoint = processPoint;
        _nowProcessName = _processPoint.name;

        IniProcess();
    }

    //初始化流程内容
    protected virtual void IniProcess()
    {
        
    }

    //流程切换
    protected void ChangeProcess(string pName)
    {
        _nowProcessManager.ProcessChange(_nowProcessName, pName);
    }

    //继承重写销毁函数 
    public virtual void OnDestroy()
    {
        GameObject.Destroy(_processPoint);
    }

}