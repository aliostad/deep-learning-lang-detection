using System;
using System.Collections;
using System.Collections.Generic;
using NetworkCommsDotNet;
using NetworkCommsDotNet.Connections;

namespace EzClientLib
{
    public class DispatchData
    {
        public Action<DispatchData> action;
        public PacketHeader packetHeader;
        public Connection connection;
        public MessageData messageData;

        public DispatchData(Action<DispatchData> a, PacketHeader p, Connection c, MessageData m)
        {
            action = a;
            packetHeader = p;
            connection = c;
            messageData = m;
        }
    }

    public class DispatchQueue
    {
        private static DispatchQueue instance;
        public static DispatchQueue Instance
        {
            get { return instance; }
        }

        //public Queue<Action<PacketHeader, Connection, MessageData>> dispatchQueue;
        public Queue<DispatchData> dispatchQueue;

        public DispatchQueue()
        {
            instance = this;
            dispatchQueue = new Queue<DispatchData>();

            //dispatchQueue.Enqueue(() => { Debug.Log("Lambda expression"); });
        }

        public void Dispatch()
        {
            for (int i = 0; i < 30; i++) {
                if (dispatchQueue.Count > 0) {
                    DispatchData data = dispatchQueue.Dequeue();
                    data.action(data);
                } else {
                    break;
                }
            }
        }

        public void Enqueue(Delegate a, PacketHeader p, Connection c, MessageData m)
        {
            DispatchData data = new DispatchData((Action<DispatchData>)a, p, c, m);
            dispatchQueue.Enqueue(data);
        }
    }
}


