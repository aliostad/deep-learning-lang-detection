package facade;

import org.springframework.beans.factory.annotation.Autowired;

import service.CoordsService;

import service.SquareCalcService;

public class GeoFacade implements iGeoFacade{
    
    @Autowired
    private CoordsService coordsService;     
    
    @Autowired
    private SquareCalcService squareCalcService; 
    

    @Override
    public SquareCalcService getSquareCalcService() {
        return squareCalcService;
    }    
    @Override
    public CoordsService getCoordsService() {
        return coordsService;
    }
 
}
