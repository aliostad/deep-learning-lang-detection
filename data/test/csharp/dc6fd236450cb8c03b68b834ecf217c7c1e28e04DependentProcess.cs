namespace AutoProcessor
{
    public class DependentProcess:Process
    {
        private Process _mainProcess;

        private Process _flagProcess;

        public DependentProcess(Process mainProcess, Process flagProcess)
        {
            _mainProcess = mainProcess;

            _flagProcess = flagProcess;

            ProcessStatus = Status.NotStarted;
        }

        public override void Start()
        {
            ProcessStatus = Status.Launched;

            if (_flagProcess.ProcessStatus == Status.Finished)
                NextProcess = _mainProcess;
            else
                NextProcess = _mainProcess.NextProcess;

            ProcessStatus = Status.Finished;
        }
    }
}
