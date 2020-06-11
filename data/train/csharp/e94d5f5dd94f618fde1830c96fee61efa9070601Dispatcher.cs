using System;
using System.Collections.Generic;
using System.Linq;
using uGaMa.Command;
using uGaMa.Mediate;

namespace uGaMa.Manager
{
    public class Dispatcher
    {
        public Dictionary<object, Dictionary<Action<NotifyParam>, uGaMaBehaviour>> dispatchList;

        public Dispatcher()
        {
            dispatchList = new Dictionary<object, Dictionary<Action<NotifyParam>, uGaMaBehaviour>>();
        }

        CommandBinder commandMap
        {
            get
            {
                return BaseGameManager.GetInstance().commandMap;        
            }
        }
        
        MediatorBinder mediatorMap
        {
            get
            {
                return BaseGameManager.GetInstance().mediatorMap;
            }
        }

        public void AddListener(uGaMaBehaviour obj, object dispatchKey, Action<NotifyParam> callback)
        {
            if(!dispatchList.ContainsKey(dispatchKey))
            {
                Dictionary<Action<NotifyParam>, uGaMaBehaviour> actions = new Dictionary<Action<NotifyParam>, uGaMaBehaviour>();
                actions.Add(callback, obj);
                dispatchList.Add(dispatchKey, actions);
            }
            else
            {
                Dictionary<Action<NotifyParam>, uGaMaBehaviour> actions = dispatchList[dispatchKey];
                actions.Add(callback, obj);
            }
        }

        public void RemoveListener(uGaMaBehaviour obj, object dispatchKey, Action<NotifyParam> callback)
        {
            if(dispatchList.ContainsKey(dispatchKey))
            {
                Dictionary<Action<NotifyParam>, uGaMaBehaviour> actions = dispatchList[dispatchKey];
                for (int i = 0; i < actions.Count; i++)
                {
                    if(actions.Keys.ElementAt(i) == callback && actions.Values.ElementAt(i) == obj)
                    {
                        actions.Remove(actions.Keys.ElementAt(i));
                    }
                }
            }
        }

        public void RemoveAllListeners(uGaMaBehaviour obj)
        {
            foreach (KeyValuePair<object, Dictionary<Action<NotifyParam>, uGaMaBehaviour>> item in dispatchList)
            {
                Dictionary<Action<NotifyParam>, uGaMaBehaviour> actions = item.Value;
                if(actions.ContainsValue(obj))
                {
                    for (int i = 0; i < actions.Count; i++)
                    {
                        if(actions.Values.ElementAt(i) == obj)
                        {
                            actions.Remove(actions.Keys.ElementAt(i));
                        }
                    }
                }
            }
        }
        
        public void Dispatch(object dispatchKey, object dispatchParam, object dispatchMsg)
        {
            NotifyParam notify = new NotifyParam(dispatchKey, dispatchParam, dispatchMsg);
            commandMap.ExecuteCommand(notify);
            SendNotifyToObject(notify);
        }

        public void Dispatch(object dispatchKey, object dispatchParam)
        {
            NotifyParam notify = new NotifyParam(dispatchKey, dispatchParam, null);
            commandMap.ExecuteCommand(notify);
            SendNotifyToObject(notify);
        }

        public void Dispatch(object dispatchKey)
        {
            NotifyParam notify = new NotifyParam(dispatchKey, null, null);
            commandMap.ExecuteCommand(notify);
            SendNotifyToObject(notify);
        }

        private void SendNotifyToObject(NotifyParam notify)
        {
            if(dispatchList.ContainsKey(notify.key))
            {
                Dictionary<Action<NotifyParam>, uGaMaBehaviour> actions = dispatchList[notify.key];

                for (int i = 0; i < actions.Count; i++)
                {
                    uGaMaBehaviour tmpBehavior = actions.Values.ElementAt(i);
                    tmpBehavior.OnHandlerNotify(notify, actions.Keys.ElementAt(i));
                }
            }
        }
    }
}
