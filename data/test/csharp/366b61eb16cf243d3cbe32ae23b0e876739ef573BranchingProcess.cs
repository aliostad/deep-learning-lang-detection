namespace AutoProcessor
{
    public class BranchingProcess : Process
    {
        private Process _flagProcess;
        private Process _ifFinished;
        private Process _ifNotFinished;

        public BranchingProcess(Process flagProcess, Process ifFinished, Process ifNotFinished)
        {
            _flagProcess = flagProcess;

            _ifFinished = ifFinished;

            _ifNotFinished = ifNotFinished;

            ProcessStatus = Status.NotStarted;
        }

        public override void Start()
        {
            ProcessStatus = Status.Launched;

            if (_flagProcess.ProcessStatus == Status.Finished)
                NextProcess = _ifFinished;
            else
                NextProcess = _ifNotFinished;

            ProcessStatus = Status.Finished;
        }
    }
}
