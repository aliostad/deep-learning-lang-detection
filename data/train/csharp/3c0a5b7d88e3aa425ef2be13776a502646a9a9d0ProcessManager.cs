using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Manages the processes. Processes can be looped.
/// </summary>
public class ProcessManager : Singleton<ProcessManager>
{
    public bool IsLoop = true;

    private readonly List<Process> _processList = new List<Process>();
    private int _processPointer;
    private Process _currentProcess;

    protected override void Awake()
    {
        base.Awake();

        _processList.Clear();

        _processList.Add(new SpawnWaveProcess(asteroids: 10));
        _processList.Add(new WaitProcess(waitTime: 10f));
        _processList.Add(new SpawnWaveProcess(asteroids: 30));
        _processList.Add(new WaitProcess(waitTime: 10f));

        _currentProcess = _processList[_processPointer];
    }

    /// <summary>
    /// Gets the count of active processes. This does not count
    /// the child processes of active processes.
    /// </summary>
    public int ProcessCount
    {
        get { return _processList.Count; }
    }

    /// <summary>
    /// Attaches a new active process.
    /// </summary>        
    public void Attach(Process process)
    {
        _processList.Add(process);
    }

    /// <summary>
    /// Sets the state of all active processes to aborted.
    /// </summary>
    public void AbortAll()
    {
        foreach (Process process in _processList)
        {
            process.State = ProcessState.Aborted;
        }
    }

    /// <summary>
    /// Updates all the active processes.
    /// </summary>
    /// <returns>Number of succeeded and failed processes.</returns>
    private void FixedUpdate()
    {
        if (_currentProcess == null)
            return;

        // Process is uninitialized, so initialize it.
        if (_currentProcess.State == ProcessState.Uninitialized)
        {
            _currentProcess.OnInit();
        }

        // Update the process, if it is running.
        if (_currentProcess.State == ProcessState.Running)
        {
            _currentProcess.OnUpdate(Time.fixedDeltaTime);
        }

        if (_currentProcess.IsDead)
        {
            switch (_currentProcess.State)
            {
                case ProcessState.Succeeded:
                    _currentProcess.OnSuccess();
                    IEnumerable<Process> children = _currentProcess.PeekChildren();
                    if (children != null)
                    {
                        foreach (Process child in children)
                        {
                            Attach(child);
                            child.OnAttach();
                        }
                    }
                    break;

                case ProcessState.Failed:
                    _currentProcess.OnFail();
                    break;

                case ProcessState.Aborted:
                    _currentProcess.OnAbort();
                    break;
            }

            _currentProcess = _processList.GetNextElement(ref _processPointer, loop: IsLoop);
            if (IsLoop)
                _currentProcess.Reset();
        }
    }
}
