using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Engine.Implementations.ActionItems
{
    public class DispatchItem
    {
        public Player Player { get; private set; }
        public Node DispatchDestination { get; private set; }
        public int Cost { get; private set; }

        public DispatchItem(Player player, Node dispatchDestination, int cost)
        {
            Player = player;
            DispatchDestination = dispatchDestination;
            Cost = cost;
        }
    }
}
