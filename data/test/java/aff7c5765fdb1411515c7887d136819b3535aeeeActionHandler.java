package com.whiuk.philip.rpg.actionHandlers;


/**
 * The controller that reacts to game actions.
 * @author Philip
 *
 */
public class ActionHandler {
    private NPCHandler npcHandler;
    private CombatHandler combatHandler;
    private MagicHandler magicHandler;
    private ItemHandler itemHandler;
    private MovementHandler movementHandler;
    private GameHandler gameHandler;

    /**
     * @return NPC handler
     */
    public NPCHandler getNPCHandler() {
        // TODO Auto-generated method stub
        return npcHandler;
    }
    /**
     * 
     * @return Combat handler
     */
    public CombatHandler getCombatHandler() {
        // TODO Auto-generated method stub
        return combatHandler;
    }

    /**
     * 
     * @return Magic handler
     */
    public MagicHandler getMagicHandler() {
        // TODO Auto-generated method stub
        return magicHandler;
    }

    /**
     * 
     * @return Item handler
     */
    public ItemHandler getItemHandler() {
        // TODO Auto-generated method stub
        return itemHandler;
    }
    /**
     * 
     * @return Movement handler
     */
    public MovementHandler getMovementHandler() {
        // TODO Auto-generated method stub
        return movementHandler;
    }
    /**
     * @return Game handler
     */
    public GameHandler getGameHandler() {
        // TODO Auto-generated method stub
        return gameHandler;
    }
}
