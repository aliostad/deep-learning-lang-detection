using DamageCalc.Components;
using Hearthstone_Deck_Tracker.Hearthstone;
using System;

namespace DamageCalc.Dispatcher
{
    class PluginDispatcher
    {
        public event EventHandler<Payload> Dispatch;

        protected void DispatchPayload(Payload payload)
        {
            if (Dispatch != null)
                Dispatch(this, payload);
        }

        public void OnActionReceived(Actions.ACTION_TYPE actionType, Card c = null)
        {
            Payload payload = new Payload();

            if (c != null) payload.Card = c;

            payload.ActionType = actionType;

            DispatchPayload(payload);

        }
    }
}
