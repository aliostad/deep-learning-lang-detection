// Gerekir ise kullanılacak olan Adapter Class'ları

namespace Nvsg.WinService.Processes
{
    public class BgjAdapter : ICloudProcess
    {
        private readonly ICloudProcess _bgjProcess;

        public BgjAdapter(ICloudProcess bgjProcess)
        {
            _bgjProcess = bgjProcess;
        }

        public void Process() => _bgjProcess.Process();

        public void Run() =>_bgjProcess.Run();

        public string Route => _bgjProcess.Route;
    }

    public class CompareResultAdapter : ICloudProcess
    {
        private readonly ICloudProcess _compareResultProcess;

        public CompareResultAdapter(ICloudProcess compareResultProcess)
        {
            _compareResultProcess = compareResultProcess;
        }
        public void Run() => _compareResultProcess.Run();

        public void Process() => _compareResultProcess.Process();

        public string Route => _compareResultProcess.Route;
    }

    public class DumpAdapter : ICloudProcess
    {
        private readonly ICloudProcess _dumpProcess;

        public DumpAdapter(ICloudProcess dumpProcess)
        {
            _dumpProcess = dumpProcess;
        }

        public void Run() => _dumpProcess.Run();

        public void Process() => _dumpProcess.Process();

        public string Route => _dumpProcess.Route;
    }

    public class EditOpenAdapter : ICloudProcess
    {
        private readonly ICloudProcess _editOpenProcess;

        public EditOpenAdapter(ICloudProcess editOpenProcess)
        {
            _editOpenProcess = editOpenProcess;
        }

        public void Run() => _editOpenProcess.Run();

        public void Process() => _editOpenProcess.Process();

        public string Route => _editOpenProcess.Route;
    }

    public class ExceptionAdapter : ICloudProcess
    {
        private readonly ICloudProcess _exceptionProcess;

        public ExceptionAdapter(ICloudProcess exceptionProcess)
        {
            _exceptionProcess = exceptionProcess;
        }

        public void Run() => _exceptionProcess.Run();

        public void Process() => _exceptionProcess.Process();

        public string Route => _exceptionProcess.Route;
    }

    public class HardwareAdapter : ICloudProcess
    {
        private readonly ICloudProcess _hardwareProcess;

        public HardwareAdapter(ICloudProcess hardwareProcess)
        {
            _hardwareProcess = hardwareProcess;
        }

        public void Run() => _hardwareProcess.Run();

        public void Process() => _hardwareProcess.Process();

        public string Route => _hardwareProcess.Route;
    }

    public class HourAverageAdapter : ICloudProcess
    {
        private readonly ICloudProcess _hourAverageProcess;

        public HourAverageAdapter(ICloudProcess hourAverageProcess)
        {
            _hourAverageProcess = hourAverageProcess;
        }

        public void Run() => _hourAverageProcess.Run();

        public void Process() => _hourAverageProcess.Process();

        public string Route => _hourAverageProcess.Route;
    }

    public class LockAdapter : ICloudProcess
    {
        private readonly ICloudProcess _lockProcess;

        public LockAdapter(ICloudProcess lockProcess)
        {
            _lockProcess = lockProcess;
        }

        public void Run() => _lockProcess.Run();

        public void Process() => _lockProcess.Process();

        public string Route => _lockProcess.Route;
    }

    public class MonthlyStatusAdapter : ICloudProcess
    {
        private readonly ICloudProcess _montyhlyStatusProcess;

        public MonthlyStatusAdapter(ICloudProcess montyhlyStatusProcess)
        {
            _montyhlyStatusProcess = montyhlyStatusProcess;
        }

        public void Run() => _montyhlyStatusProcess.Run();

        public void Process() => _montyhlyStatusProcess.Process();

        public string Route => _montyhlyStatusProcess.Route;
    }

    public class ParamsAdapter : ICloudProcess
    {
        private readonly ICloudProcess _paramsProcess;

        public ParamsAdapter(ICloudProcess paramsProcess)
        {
            _paramsProcess = paramsProcess;
        }

        public void Run() => _paramsProcess.Run();

        public void Process() => _paramsProcess.Process();

        public string Route => _paramsProcess.Route;
        
    }

    public class Sm21Adapter : ICloudProcess
    {
        private readonly ICloudProcess _sm21Process;

        public Sm21Adapter(ICloudProcess sm21Process)
        {
            _sm21Process = sm21Process;
        }

        public void Run() => _sm21Process.Run();

        public void Process() => _sm21Process.Process();

        public string Route => _sm21Process.Route;

    }

    public class StmsAdapter : ICloudProcess
    {
        private readonly ICloudProcess _stmsProcess;

        public StmsAdapter(ICloudProcess stmsProcess)
        {
            _stmsProcess = stmsProcess;
        }

        public void Run() => _stmsProcess.Run();

        public void Process() => _stmsProcess.Process();

        public string Route => _stmsProcess.Route;
    }

    public class UserTrxAdapter : ICloudProcess
    {
        private readonly ICloudProcess _userTrxProcess;

        public UserTrxAdapter(ICloudProcess userTrxProcess)
        {
            _userTrxProcess = userTrxProcess;
        }

        public void Run() => _userTrxProcess.Run();

        public void Process() => _userTrxProcess.Process();

        public string Route => _userTrxProcess.Route;
    }

}
