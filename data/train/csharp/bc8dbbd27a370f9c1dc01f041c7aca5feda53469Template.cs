public class Template {
	public static Template S = null;

	#region Controller vars /// @name Controller vars
	//private DisabledTileController disabledTileController = null; //!< The local reference to the disabled tile's controller
	//private GameController gameController = null; //!< The local reference to the game controller
	//private HighlightsController highlightsController = null; //!< The local reference to the highlight's controller
	//private MapsController mapsController = null; //!< The local reference to the maps controller
	//private ModalsController modalsController = null; //!< The local reference to the ModalsController
	//private MovementController movementController = null; //!< The local reference to the movement's controller
	//private NetworkController networkController = null; //!< The local reference to the network controller and API
	//private NavController navController = null; //!< The local reference to the nav controller
	//private PlayerController playerController = null; //!< The local reference to the player's controller
	//private ResourceTileController resourceTileController = null; //!< The local reference to the resource tile's controller
	//private RemoteCamera remoteCamera = null; //!< The local reference to the remote camera's script
	//private TilesController tilesController = null; //!< The local reference to the TilesController
	//private TurnsController turnsController = null; //!< The local reference to the TurnsController
	//private UIController uiController = null; //!< The local reference to the UIController
	//private UnitsController unitsController = null; //!< The local reference to the unit's controller
	#endregion

	#region Unity methods /// @name Unity methods
	/**
	 * Called when the script is loaded, before the game starts
	 */
	void Awake () {
		S = this;
	}

	/**
	 * Runs at load time
	 */
	void Start () {
		//disabledTileController = DisabledTileController.S;
		//gameController = GameController.S;
		//highlightsController = HighlightsController.S;
		//mapsController = MapsController.S;
		//modalsController = ModalsController.S;
		//movementController = MovementController.S;
		//navController = NavController.S;
		//networkController = NetworkController.S;
		//playerController = PlayerController.S;
		//resourceTileController = ResourceTileController.S;
		//remoteCamera = RemoteCamera.S;
		//tilesController = TilesController.S;
		//turnsController = TurnsController.S;
		//uiController = UIController.S;
		//unitsController = UnitsController.S;
	}
	#endregion
}