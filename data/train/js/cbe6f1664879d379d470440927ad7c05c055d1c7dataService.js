agbeServices.factory('dataService', ['$log','persistenceService', function ($log,persistenceService) {

    var dataService = {

        CHARACTER_DATA_KEY : 'CHARACTER_DATA_KEY',
        characterData : undefined,

        INVENTORY_DATA_KEY : 'INVENTORY_DATA_KEY',
        inventoryData : undefined,

        STORY_DATA_KEY : 'STORY_DATA_KEY',
        storyData : undefined,

        WORLD_DATA_KEY : 'WORLD_DATA_KEY',
        worldData : undefined,

        load : function() {
            $log.log("dataService.load");
            dataService.characterData = persistenceService.objectFromPersistence(dataService.CHARACTER_DATA_KEY);
            dataService.inventoryData = persistenceService.objectFromPersistence(dataService.INVENTORY_DATA_KEY);
            dataService.storyData = persistenceService.objectFromPersistence(dataService.STORY_DATA_KEY);
        },


        save : function() {
            $log.log("dataService.save");
            persistenceService.objectToPersistence(dataService.CHARACTER_DATA_KEY,dataService.characterData);
            persistenceService.objectToPersistence(dataService.INVENTORY_DATA_KEY,dataService.inventoryData);
            persistenceService.objectToPersistence(dataService.STORY_DATA_KEY,dataService.storyData);
        }

    }
    return dataService;
}]);
