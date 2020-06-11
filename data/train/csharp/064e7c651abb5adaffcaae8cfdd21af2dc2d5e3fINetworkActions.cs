using System.Collections.Generic;
using NetworkTypes;

namespace Server
{
    interface INetworkActions
    {
        RemoteInvokeMethod Login(Authentication authentification);
        RemoteInvokeMethod Logout(Authentication authentification);
        RemoteInvokeMethod Register(Authentication authentification);
        RemoteInvokeMethod Join(LobbyInfo args);
        RemoteInvokeMethod Create(LobbyInfo args);
        RemoteInvokeMethod ChangeTeam(LobbyInfo args);
        RemoteInvokeMethod Leave(LobbyInfo args);
        RemoteInvokeMethod Disconnect(LobbyInfo args);
    }
}
