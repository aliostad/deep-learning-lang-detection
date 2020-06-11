using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Redis2Go.Helpers
{
    public class RedisProcess : IRedisProcess
    {
        private readonly Process _process;

        public IEnumerable<string> ErrorOutput { get; set; }
        public IEnumerable<string> StandardOutput { get; set; }

        internal RedisProcess(Process process)
        {
            this._process = process;
        }

        public void Dispose()
        {
            if (this._process != null)
                this._process.Kill();
            GC.SuppressFinalize(this);
        }
    }
}
