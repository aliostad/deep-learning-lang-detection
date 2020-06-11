namespace THOK.UDP.Dispatch
{
    using System;
    using System.Net;
    using THOK.UDP;
    using THOK.UDP.Util;

    public class DispatchClient : Client
    {
        private string dispatchServerName;
        private string name;

        public DispatchClient(string dispatchServerName, string hostIP, int port) : base(hostIP, port)
        {
            this.dispatchServerName = "Dispatcher";
            this.name = "Client";
            this.dispatchServerName = dispatchServerName;
            this.name = Dns.GetHostName();
        }

        public DispatchClient(string dispatchServerName, string hostIP, int port, string name) : base(hostIP, port)
        {
            this.dispatchServerName = "Dispatcher";
            this.name = "Client";
            this.dispatchServerName = dispatchServerName;
            this.name = name;
        }

        public void GetRegistedClient()
        {
            MessageGenerator generator = new MessageGenerator("CLIENTS", this.name);
            generator.AddReceiver(this.dispatchServerName);
            base.Send(generator.GetMessage());
        }

        public void Register(int port)
        {
            string ip = "127.0.0.1";
            IPHostEntry hostEntry = Dns.GetHostEntry(Dns.GetHostName());
            if (hostEntry.AddressList.Length != 0)
            {
                ip = hostEntry.AddressList[0].ToString();
            }
            this.Register(ip, port);
        }

        public void Register(string ip, int port)
        {
            MessageGenerator generator = new MessageGenerator("REG", this.name);
            generator.AddReceiver(this.dispatchServerName);
            generator.AddReceiver(this.name);
            generator.AddParameter("IP", ip);
            generator.AddParameter("Port", port.ToString());
            base.Send(generator.GetMessage());
        }

        public void Unregister()
        {
            MessageGenerator generator = new MessageGenerator("UNREG", this.name);
            generator.AddReceiver(this.dispatchServerName);
            base.Send(generator.GetMessage());
        }

        public string DispatchServerName
        {
            get
            {
                return this.dispatchServerName;
            }
        }

        public string Name
        {
            get
            {
                return this.name;
            }
        }
    }
}

