using System.Diagnostics;

namespace MovieHouse
{
    public class MoviePlayer
    {
        private Process _process;

        public void Play(string fileName)
        {
            if (_process == null)
                _process = new Process();

            _process.StartInfo = new ProcessStartInfo(fileName);
            _process.Start();
        }

        public void Stop()
        {
            if (_process == null || _process.HasExited)
                return;
            
            _process.Close();
        }
    }
}