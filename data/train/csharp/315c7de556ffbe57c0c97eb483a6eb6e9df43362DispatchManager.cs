using Engine.CustomEventArgs;
using Engine.Implementations.ActionItems;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Engine.Implementations.ActionManagers
{
    internal class DispatchManager
    {
        private Player player;
        private IEnumerable<Player> players;

        internal IEnumerable<DispatchItem> Destinations { get; private set; }

        internal DispatchManager(Player player, IEnumerable<Player> players)
        {
            if (player is Dispatcher)
            {
                this.player = player;
                this.players = players;

                this.player.Moved += PlayerMoved;
                this.player.ActionCounter.ActionUsed += ActionUsed;

                foreach (Player sub in players)
                {
                    sub.Moved += PlayerMoved;
                }

                Update();
            }
        }

        private void Update()
        {
            Destinations = GetDispatchDestinations();
        }

        private void PlayerMoved(object sender, PlayerMovedEventArgs e)
        {
            Update();
        }

        private void ActionUsed(object sender, EventArgs e)
        {
            Update();
        }

        internal bool CanDispatch(DispatchItem dispatchItem)
        {
            return dispatchItem != null;
        }

        internal void Dispatch(DispatchItem dispatchItem)
        {
            if(CanDispatch(dispatchItem))
            {
                dispatchItem.Player.Move(dispatchItem.DispatchDestination);
                player.ActionCounter.UseAction(dispatchItem.Cost);
            }
        }

        private IEnumerable<DispatchItem> GetDispatchDestinations()
        {
            List<DispatchItem> destinations = new List<DispatchItem>();

            if (player.ActionCounter.Count == 0)
                return destinations;

            foreach (Player player in players)
            {

                DriveManager dm = new DriveManager(player);
                foreach (DriveDestinationItem ddi in dm.GetDestinations(this.player.ActionCounter.Count))
                {
                    if (ddi.Node.Players.Count() == 0)
                        destinations.Add(new DispatchItem(player, ddi.Node, ddi.Cost));
                }

                foreach (Player sub in players)
                {
                    if (sub.Location != player.Location && destinations.Where(i => i.Player == player && i.DispatchDestination == sub.Location).Count() == 0)
                        destinations.Add(new DispatchItem(player, sub.Location, 1));
                }
            }

            return destinations;
        }
        
    }
}
