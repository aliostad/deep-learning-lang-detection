using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Web;

namespace PCTV.ExternalInput.Service
{
    [ServiceContract]
    public interface IExternalInput
    {
        [WebInvoke(Method = "POST")]
        void Up();

        [WebInvoke(Method = "POST")]
        void Down();

        [WebInvoke(Method = "POST")]
        void Right();

        [WebInvoke(Method = "POST")]
        void Left();

        [WebInvoke(Method = "POST")]
        void Enter();

        [WebInvoke(Method = "POST")]
        void EnterString(string value);

        [WebInvoke(Method = "POST")]
        void UpVolume();

        [WebInvoke(Method = "POST")]
        void DownVolume();

        [WebInvoke(Method = "POST")]
        void Mute();

        [WebInvoke(Method = "POST")]
        void Play();

        [WebInvoke(Method = "POST")]
        void Pause();

        [WebInvoke(Method = "POST")]
        void Stop();
    }
}
