package com.byteme.Injection;

import com.byteme.Controllers.BoardController;
import com.byteme.Handlers.*;
import com.byteme.Models.LandPurchaseStore;
import com.byteme.Models.MULEStore;

/**
 * Created by rishav on 12/3/2015.
 */
public class HandlerInjector {
    private static HandlerInjector ourInstance = new HandlerInjector();

    public static HandlerInjector getInstance() {
        return ourInstance;
    }

    private EmptyHandler emptyHandler;

    private GameStartHandler gameStartHandler;

    private LandGrantHandler landGrantHandler;

    private LandPurchaseHandler landPurchaseHandler;

    private PlaceMuleHandler placeMuleHandler;

    private SelectionOverHandler selectionOverHandler;

    private TurnOverHandler turnOverHandler;

    private HandlerInjector() {
        BoardController boardController = ControllerInjector.getInstance().getBoardController();

        emptyHandler = new EmptyHandler(boardController);

        gameStartHandler = new GameStartHandler(boardController);

        landGrantHandler = new LandGrantHandler(boardController);

        landPurchaseHandler = new LandPurchaseHandler(boardController);

        placeMuleHandler = new PlaceMuleHandler(boardController);

        selectionOverHandler = new SelectionOverHandler(boardController);

        turnOverHandler = new TurnOverHandler(boardController);
    }

    public EmptyHandler getEmptyHandler() {
        return emptyHandler;
    }

    public GameStartHandler getGameStartHandler() {
        return gameStartHandler;
    }

    public LandGrantHandler getLandGrantHandler() {
        return landGrantHandler;
    }

    public LandPurchaseHandler getLandPurchaseHandler() {
        return landPurchaseHandler;
    }

    public PlaceMuleHandler getPlaceMuleHandler() {
        return placeMuleHandler;
    }

    public SelectionOverHandler getSelectionOverHandler() {
        return selectionOverHandler;
    }

    public TurnOverHandler getTurnOverHandler() {
        return turnOverHandler;
    }
}
