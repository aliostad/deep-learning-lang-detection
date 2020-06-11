using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using XCClientAPICommon.ApiExtensions;
using XComponent.SequenceDiagramProject.SequenceDiagramProjectApi;
using XComponent.SequenceDiagramProject.SequenceDiagramProjectApi.SimpleComponent;

namespace SequenceDiagramViewer
{
    class ClientApiWrapper
    {
        private ClientApiWrapper()
        {
            
        }

        public static ClientApiWrapper Instance { get; } = new ClientApiWrapper();

        public SequenceDiagramProjectApi Api
        {
            get { return _api; }
            set { _api = value; }
        }

        private SequenceDiagramProjectApi _api;

        public bool Init()
        {
            try
            {
                // Initialize the interfaces
                var mySequenceDiagramProjectApi = new ApiWrapper<SequenceDiagramProjectApi>();
                {
                    ClientApiOptions clientApiOptions = new ClientApiOptions(); //fill this object to override default xcApi parameters

                    if (mySequenceDiagramProjectApi.Init(mySequenceDiagramProjectApi.Api.DefaultXcApiFileName, clientApiOptions))
                    {
                        _api = mySequenceDiagramProjectApi.Api;

                        return true;
                    }

                }

            }
            catch (Exception)
            {
                
            }

            return false;
        }

    }
}
