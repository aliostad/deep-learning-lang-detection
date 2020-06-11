(function() {
    'use strict';

    var RandomNumbersService = require('./randomNumbersService'),
        DealingService = require('./dealingService');

    var GameLogicService = function() {
        this.randomNumbersService = new RandomNumbersService();
        this.dealingService = new DealingService(this.randomNumbersService);
    };

    GameLogicService.prototype.setRandomNumbersService = function(randomNumbersService) {
        this.randomNumbersService = randomNumbersService;
    };

    GameLogicService.prototype.initializeGame = function(game) {
        game.setDeck(this.randomNumbersService.getRandomNumbers(1, 40, 40));
        game.setHand(this.randomNumbersService.getRandomNumbers(0, 3, 1)[0]);
        game.setTurn(game.getHand());
        game.resetCards();
        this.dealingService.dealCards(game, true);
    };

    module.exports = GameLogicService;

})();