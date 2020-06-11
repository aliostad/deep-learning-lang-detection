package controller.game.handler;
import de.upb.tools.fca.*;
import java.util.*;

import org.json.JSONException;
import org.json.JSONObject;

import controller.game.handler.property.association.AvailableResourcesHandler;
import controller.game.handler.property.association.BuildingsHandler;
import controller.game.handler.property.association.CollectedResourcesHandler;
import controller.game.handler.property.association.CollectingHandler;
import controller.game.handler.property.association.MessagesHandler;
import controller.game.handler.property.association.OwnerHandler;
import controller.game.handler.property.association.PeonsHandler;
import controller.game.handler.property.association.PropertyAllianceHandler;
import controller.game.handler.property.association.PropertyGameHandler;
import controller.game.handler.property.association.PropertyMapHandler;
import controller.game.handler.property.association.PropertySectorHandler;
import controller.game.handler.property.association.PropertySectorsHandler;
import controller.game.handler.property.association.PropertyTeamHandler;
import controller.game.handler.property.association.PropertyTowerHandler;
import controller.game.handler.property.association.PropertyUserAssetsHandler;
import controller.game.handler.property.association.PropertyUserHandler;
import controller.game.handler.property.association.ResourcesHandler;
import controller.game.handler.property.association.StartingUserHandler;
import controller.game.handler.property.association.UnitsHandler;
import controller.game.handler.property.association.UsersHandler;
import controller.game.handler.property.association.UsersToStartHandler;
import controller.game.handler.property.association.WinnerHandler;
import controller.game.handler.property.association.WorkingOnHandler;
import controller.game.handler.property.value.BuildProgressHandler;
import controller.game.handler.property.value.ColorHandler;
import controller.game.handler.property.value.HPHandler;
import controller.game.handler.property.value.LevelHandler;
import controller.game.handler.property.value.NameHandler;
import controller.game.handler.property.value.NicknameHandler;
import controller.game.handler.property.value.QuantityHandler;
import controller.game.handler.property.value.RunningHandler;
import controller.game.handler.property.value.StartSectorHandler;
import controller.game.handler.property.value.StrengthHandler;
import controller.game.handler.property.value.TextHandler;
import controller.game.handler.property.value.TypeHandler;
import controller.game.handler.property.value.UnitCreationProgressHandler;
import controller.game.handler.property.value.UnitLevelInCreationHandler;
import controller.game.handler.property.value.UnitTypeInCreationHandler;
import controller.game.handler.property.value.UpgradingHandler;
import controller.game.handler.property.value.XHandler;
import controller.game.handler.property.value.YHandler;

public abstract class MessageHandler {
/**
    * <pre>
    *           1..1     0..n
    * MessageHandler ------------------------- PropertyHandler
    *           messageHandler        &gt;       propertyHandler
    * </pre>
    */
   
   private FHashSet propertyHandler;
   
   public boolean addToPropertyHandler (PropertyHandler value)
   {
      boolean changed = false;
   
      if (value != null)
      {
         if (this.propertyHandler == null)
         {
            this.propertyHandler = new FHashSet ();
   
         }
         changed = this.propertyHandler.add (value);
         if (changed)
         {
            value.setMessageHandler(this);
         }
      }
      return changed;
   }
   
   public boolean removeFromPropertyHandler (PropertyHandler value)	
   {
      boolean changed = false;
   
      if ((this.propertyHandler != null) && (value != null))
      {
         changed = this.propertyHandler.remove (value);
         if (changed)
         {
            value.setMessageHandler(null);
         }
      }
      return changed;
   }
   
   public void removeAllFromPropertyHandler ()
   {
   PropertyHandler tmpValue;
      Iterator iter = this.iteratorOfPropertyHandler ();
   
      while (iter.hasNext ())
      {
         tmpValue = (PropertyHandler) iter.next ();
         this.removeFromPropertyHandler (tmpValue);
      }
   }
   
   public boolean hasInPropertyHandler (PropertyHandler value)
   {
      return ((this.propertyHandler != null) &&
              (value != null) &&
              this.propertyHandler.contains (value));
   }
   
   public Iterator iteratorOfPropertyHandler ()
   {
      return ((this.propertyHandler == null)
              ? FEmptyIterator.get ()
              : this.propertyHandler.iterator ());
   
   }
   
   public int sizeOfPropertyHandler ()
   {
      return ((this.propertyHandler == null)
              ? 0
              : this.propertyHandler.size ());
   }
/**
    * <pre>
    *           0..n     1..1
    * MessageHandler ------------------------- ChainMaster
    *           messageHandler        &lt;       chainMaster
    * </pre>
    */
   
   private ChainMaster chainMaster;
   
   public boolean setChainMaster (ChainMaster value)		
   {
      boolean changed = false;
   
      if (this.chainMaster != value)
      {
   ChainMaster oldValue = this.chainMaster;
         if (this.chainMaster != null)
         {
            this.chainMaster = null;
            oldValue.removeFromMessageHandler(this);
         }
         this.chainMaster = value;
   
         if (value != null)
         {
            value.addToMessageHandler(this);
         }
         changed = true;
      }
      return changed;
   }
   
   public ChainMaster getChainMaster ()	
   {
      return this.chainMaster;
   }
   public void removeYou()
   {
   this.removeAllFromPropertyHandler ();
      this.setChainMaster (null);
   }
	
	/**
	 * Constructor, which initializes property handler for different events	 * 
	 */
	
public MessageHandler() {
	   if(this.propertyHandlerMap == null){
   		   this.propertyHandlerMap = new HashMap<String, PropertyHandler>();
   	   }
   	   
   	   // Initlize your property handler here
      propertyHandlerMap.put("level", new LevelHandler());
      propertyHandlerMap.put("quantity", new QuantityHandler());
      propertyHandlerMap.put("name", new NameHandler());
      propertyHandlerMap.put("sector", new PropertySectorHandler());
      propertyHandlerMap.put("type", new TypeHandler());
      propertyHandlerMap.put("startingUser", new StartingUserHandler());
      propertyHandlerMap.put("x", new XHandler());
      propertyHandlerMap.put("y", new YHandler());
      propertyHandlerMap.put("sectors", new PropertySectorsHandler());
      propertyHandlerMap.put("map", new PropertyMapHandler());
      propertyHandlerMap.put("game", new PropertyGameHandler());
      propertyHandlerMap.put("userAssets", new PropertyUserAssetsHandler());
      propertyHandlerMap.put("user", new PropertyUserHandler());
      propertyHandlerMap.put("startSector", new StartSectorHandler());
      propertyHandlerMap.put("usersToStart", new UsersToStartHandler());
      propertyHandlerMap.put("running", new RunningHandler());
      propertyHandlerMap.put("team", new PropertyTeamHandler());
      propertyHandlerMap.put("users", new UsersHandler());
      propertyHandlerMap.put("nickname", new NicknameHandler());
      propertyHandlerMap.put("messages", new MessagesHandler());
      propertyHandlerMap.put("text", new TextHandler());
      propertyHandlerMap.put("owner", new OwnerHandler());
      propertyHandlerMap.put("alliance", new PropertyAllianceHandler());
      propertyHandlerMap.put("alliances", new PropertyAllianceHandler());
      propertyHandlerMap.put("color", new ColorHandler());
      propertyHandlerMap.put("buildProgress", new BuildProgressHandler());
      propertyHandlerMap.put("hp", new HPHandler());
      propertyHandlerMap.put("unitTypeInCreation", new UnitTypeInCreationHandler());
      propertyHandlerMap.put("unitCreationProgress", new UnitCreationProgressHandler());
      propertyHandlerMap.put("unitLevelInCreation", new UnitLevelInCreationHandler());
      propertyHandlerMap.put("collecting", new CollectingHandler());
      propertyHandlerMap.put("workingOn", new WorkingOnHandler());
      propertyHandlerMap.put("buildings", new BuildingsHandler());
      propertyHandlerMap.put("units", new UnitsHandler());
      propertyHandlerMap.put("availableResources", new AvailableResourcesHandler());
      propertyHandlerMap.put("strength", new StrengthHandler());
      propertyHandlerMap.put("resources", new ResourcesHandler());
      propertyHandlerMap.put("collectedResources", new CollectedResourcesHandler());
      propertyHandlerMap.put("tower", new PropertyTowerHandler());
      propertyHandlerMap.put("upgrading", new UpgradingHandler());
      propertyHandlerMap.put("winner", new WinnerHandler());
      propertyHandlerMap.put("peons", new PeonsHandler());
      
      
   	   // Set this as chain master for every entry in the hash map
   	   for (Object value : propertyHandlerMap.values()) {
   		   ((PropertyHandler) value).setMessageHandler(this);
   	   }
      
   }

   private HashMap<String, PropertyHandler> propertyHandlerMap;
	
	public HashMap<String, PropertyHandler> getPropertyHandlerMap() {
	   if (this.propertyHandlerMap == null) {
	this.propertyHandlerMap = new HashMap<String, PropertyHandler>();
	   }
	   return this.propertyHandlerMap;
	}
   
   public abstract void handle(JSONObject jsonObject) throws JSONException;
   
}
