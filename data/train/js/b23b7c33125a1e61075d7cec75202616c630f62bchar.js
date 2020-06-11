supernova.
    controller(
        "character",
        [
            "$scope",
            "InventoryService",
            "CharacterService",
            "ZoneService",
            function($scope, InventoryService, CharacterService, ZoneService) {
                $scope.inventory = InventoryService.inventory;
                $scope.char = {};
                $scope.init = function(id) {
                    CharacterService.getChar(id, function(char) {
                        $scope.char = char;
                        $scope.char.zone = { name: "Undefined" };
                        ZoneService.getZone($scope.char.pos_zone, function(zone) {
                            $scope.char.zone = zone;
                        });
                    });
                    InventoryService.getInventory(id);
                };
            }
        ]
    );