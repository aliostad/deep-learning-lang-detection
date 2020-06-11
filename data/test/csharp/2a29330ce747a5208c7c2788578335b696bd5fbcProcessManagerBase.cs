using System;
using UnityEngine;
using TFramework.Base;

/// <summary>
///
///流程管理基类 -- 流程一定是同时只能存在一个并且不重复
///
/// 1 流程的枚举名称
/// 2 流程的切换(初始化/卸载)
/// 3 制作流程挂点 -- 流程初始化的组件可挂在下面,切换流程自动卸载组件
///
/// </summary>
public class ProcessManagerBase : TSingleton<ProcessManagerBase>
{

    //流程名称 -- 需要加入的流程 添加到此流程枚举中 或者 使用静态字符串
    protected enum ProcessName
    {

    }

    //已启动的流程
    protected ProcessBase _nowRunProcess = null;
    public ProcessBase NowRunProcess { get { return _nowRunProcess; } }

    //流程实例化
    //根据类名进行实例化
    protected virtual void IniProcess(string processName)
    {
        //如果流程已经启动了 就跳出 
        if (CheckProcessIsInied(processName))
        {
            return;
        }
        try
        {
            //根据名称 实例化对应的流程
            Type type = Type.GetType(processName);
            ProcessBase pb = type.Assembly.CreateInstance(type.Name) as ProcessBase;

            if (pb != null)
            {
                _nowRunProcess = pb;
                GameObject obj = new GameObject(processName);
                _nowRunProcess.Initialization(this, obj);
            }
            else
            {
                Debug.LogError("流程实例化为空: " + processName);
            }
        }
        catch (Exception)
        {
            Debug.LogError("对应的流程类实例化失败: " + processName);
        }
    }

    //卸载流程
    protected virtual void EndProcess(string processName)
    {

        if (CheckProcessIsInied(processName))
        {
            _nowRunProcess.OnDestroy();
            _nowRunProcess = null;
        }
    }

    //查询当前流程是否已经创建
    protected virtual bool CheckProcessIsInied(string processName)
    {

        if (_nowRunProcess != null)
        {
            if (processName.Equals(_nowRunProcess._nowProcessName))
            {
                return true;
            }
        }

        return false;

    }

    //继承重写销毁函数 里面有基类销毁管理
    protected virtual void OnDestroy()
    {
        if (_nowRunProcess != null)
        {
            EndProcess(_nowRunProcess._nowProcessName);
        }
    }

    //结束当前流程 并且初始化下一流程
    public virtual void ProcessChange(string nowProcessName, string newProcessName)
    {
        if (!string.IsNullOrEmpty(nowProcessName))
        {
            EndProcess(nowProcessName);
        }

        if (!string.IsNullOrEmpty(newProcessName))
        {
            IniProcess(newProcessName);
        }
    }

}