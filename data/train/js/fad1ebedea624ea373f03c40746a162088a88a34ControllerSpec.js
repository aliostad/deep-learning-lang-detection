describe("Controller", function() {
  var controller;

  beforeEach(function() {
    controller = new Controller();
  });

  it("should be able to add players", function() {
    controller.addPlayer("Alex");
    controller.addPlayer("Holly");
    expect(controller.getPlayers().length).toBe(2);
  });

  it("shouldn't be able to add more than 6 players", function() {
    for(var i = 0; i < 6; i++) {
      controller.addPlayer(i.toString());
    }
    expect(controller.addPlayer("Another")).toBeFalsy();
  });

  it("shouldn't be able to add players with invalid names", function() {
    expect(controller.addPlayer()).toBeFalsy();
    expect(controller.addPlayer(null)).toBeFalsy();
    expect(controller.addPlayer("")).toBeFalsy();
    expect(controller.addPlayer("             ")).toBeFalsy();
  });

  it("should accept valid scores", function() {
    controller.addPlayer("Alex");
    controller.addPlayer("Holly");

    expect(controller.getScores(0)).toEqual([]);
    expect(controller.getScores(1)).toEqual([]);

    controller.addScore(4);
    controller.addScore(5);
    controller.addScore(2);
    controller.addScore(8);
    controller.addScore(7);
    controller.addScore(0);

    expect(controller.getScores(0)).toEqual([4, 5, 7, 0]);
    expect(controller.getScores(1)).toEqual([2, 8]);
  });

  it("should reject invalid scores", function() {
    controller.addPlayer("Alex");
    controller.addPlayer("Holly");

    expect(controller.getScores(0)).toEqual([]);
    expect(controller.getScores(1)).toEqual([]);

    expect(controller.addScore(15)).toBeFalsy();
    expect(controller.addScore(-5)).toBeFalsy();

    expect(controller.addScore(4)).toBeTruthy();
    expect(controller.addScore(8)).toBeFalsy();

    expect(controller.addScore("HELLO")).toBeFalsy();
  });

  it("should increase the current roll correctly", function() {
    controller.addPlayer("Alex");
    controller.addPlayer("Holly");
    controller.addPlayer("Laura");

    expect(controller.getCurrentRoll()).toBe(0);
    controller.addScore(2);
    expect(controller.getCurrentRoll()).toBe(1);
    controller.addScore(3);
    expect(controller.getCurrentRoll()).toBe(0);
    controller.addScore(5);
    expect(controller.getCurrentRoll()).toBe(1);
    controller.addScore(4);
    expect(controller.getCurrentRoll()).toBe(0);
    controller.addScore(10);
    expect(controller.getCurrentRoll()).toBe(2);
    controller.addScore(3);
    expect(controller.getCurrentRoll()).toBe(3);
    controller.addScore(6);
    expect(controller.getCurrentRoll()).toBe(2);
    controller.addScore(0);
    expect(controller.getCurrentRoll()).toBe(3);
  });

  it("should increase the current player correctly", function() {
    controller.addPlayer("Alex");
    controller.addPlayer("Holly");
    controller.addPlayer("Laura");

    expect(controller.getCurrentPlayer()).toBe(0);
    controller.addScore(2);
    expect(controller.getCurrentPlayer()).toBe(0);
    controller.addScore(3);
    expect(controller.getCurrentPlayer()).toBe(1);
    controller.addScore(5);
    expect(controller.getCurrentPlayer()).toBe(1);
    controller.addScore(5);
    expect(controller.getCurrentPlayer()).toBe(2);
    controller.addScore(7);
    expect(controller.getCurrentPlayer()).toBe(2);
    controller.addScore(0);
    expect(controller.getCurrentPlayer()).toBe(0);
    controller.addScore(3);
    expect(controller.getCurrentPlayer()).toBe(0);
    controller.addScore(6);
    expect(controller.getCurrentPlayer()).toBe(1);
    controller.addScore(0);
    expect(controller.getCurrentPlayer()).toBe(1);
  });
});