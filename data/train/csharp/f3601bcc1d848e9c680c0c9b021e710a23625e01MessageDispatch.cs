using System;
using System.Collections.Generic;
using System.Text;

namespace osc.net
{
    public class MessageDispatch
    {
        private Dictionary<string, List<Action<Message>>> dispatchTable = new Dictionary<string, List<Action<Message>>>();

        public void RegisterMethod(string oscMethod, Action<Message> callback) {
            if (dispatchTable.ContainsKey(oscMethod)) {
                dispatchTable[oscMethod].Add(callback);
            }
            else {
                dispatchTable[oscMethod] = new List<Action<Message>>() {
                    callback
                };
            }
        }

        public void UnregisterMethod(string oscMethod) {
            dispatchTable.Remove(oscMethod);
        }

        public void UnregisterCallback(string oscMethod, Action<Message> callback) {
            if (dispatchTable.ContainsKey(oscMethod)) {
                dispatchTable[oscMethod].Remove(callback);
            }
        }

        public void UnregisterCallback(Action<Message> callback) {
            foreach (var callbackList in dispatchTable.Values) {
                callbackList.Remove(callback);
            }
        }

        public void Dispatch(Message message) {
            if (dispatchTable.ContainsKey(message.Address)) {
                var callbackList = dispatchTable[message.Address];
                foreach (var callback in callbackList) {
                    callback(message);
                }
            }

            // TODO : partial address matching dispatch
        }
    }
}
