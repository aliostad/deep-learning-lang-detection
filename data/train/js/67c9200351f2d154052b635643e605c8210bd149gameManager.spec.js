'use strict';

describe('GameManager', function(){
    describe('playing', function(){
		var GameManagerService;

		beforeEach(module("tictactoe"));

		beforeEach(inject(function (GameManager) {
		    GameManagerService = GameManager;
		}));

        it('winners X', function(){
            GameManagerService.newGame();
            GameManagerService.move(0,0);
            GameManagerService.move(0,1);
            GameManagerService.move(1,1);
            GameManagerService.move(1,2);
            GameManagerService.move(2,2);
            expect( GameManagerService.winner ).toEqual(1);
        });

        it('winners O', function(){
            GameManagerService.newGame();
            GameManagerService.move(1,0);
            GameManagerService.move(0,0);
            GameManagerService.move(1,2);
            GameManagerService.move(0,1);
            GameManagerService.move(2,2);
            GameManagerService.move(0,2);
            expect( GameManagerService.winner ).toEqual(2);
        });

        it('tie game', function(){
            GameManagerService.newGame();
            GameManagerService.move(0,0);
            GameManagerService.move(1,0);
            GameManagerService.move(2,0);
            GameManagerService.move(1,1);
            GameManagerService.move(0,1);
            GameManagerService.move(2,1);
            GameManagerService.move(1,2);
            GameManagerService.move(0,2);
            GameManagerService.move(2,2);
            expect( GameManagerService.winner ).toEqual(-1);
        });

    });
});