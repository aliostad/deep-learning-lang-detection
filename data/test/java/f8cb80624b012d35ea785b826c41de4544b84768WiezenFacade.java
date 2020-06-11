package services;

import services.player.PlayerService;
import services.room.RoomService;
import util.MemoryLocation;

public class WiezenFacade 
{
    
    private PlayerService playerService;
    private RoomService roomService;
    
    public WiezenFacade(MemoryLocation location)
    {
        playerService = new PlayerService(location);
        roomService = new RoomService(location);
    }
    
    public PlayerService getPlayerService()
    {
        return playerService;
    }
   
    public RoomService getRoomService()
    {
        return roomService;
    }
    
    public void closeConnection()
    {
        playerService.closeConnection();
        roomService.closeConnection();
    }
}