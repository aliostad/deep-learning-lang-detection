using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProcessEx : MonoBehaviour
{
    public string processPath;
    public string processName;

    private void Start()
    {
        var allProcess = ProcessTools.ListAllAppliction();
        foreach (var item in allProcess)
        {
            Debug.Log(item);
        }
        Debug.Log("当前进程数" + allProcess.Length);
    }

    public void StartProcess()
    {
        ProcessTools.StartProcess(processPath);
    }

    public void EndProcess()
    {
        ProcessTools.KillProcess(processName);
    }
}