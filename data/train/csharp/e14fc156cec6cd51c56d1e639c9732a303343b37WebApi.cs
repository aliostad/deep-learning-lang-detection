using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SimpleBackupService.Contracts;

namespace SimpleBackupService
{
    public class WebApi : IBackupWebApi
    {
        private IBackupWebApi _webApi = null;

        public WebApi ( IBackupWebApi webApi )
        {
            _webApi = webApi;
        }

        public void Dispose ( )
        {
            _webApi?.Dispose();
        }

        public void InitWebApi ( IBackupService service )
        {
            _webApi?.InitWebApi(service);
        }
    }
}
