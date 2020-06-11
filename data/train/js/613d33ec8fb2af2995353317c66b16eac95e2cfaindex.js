'use strict';

/**
 * Gateway TBS service.
 *
 * Delegates to sub-services.
 *
 * @class
 * @implements GameRoomService
 * @implements GameTypeService
 * @implements UserService
 *
 * @param {GameRoomService}
 * @param {GameTypeService}
 * @param {UserService}
 *
 * @param {TransportService}
 */
function TbsService(gameRoomService, gameTypeService, userService, transportService) {
  gameRoomService.setService(this);
  this.gameRooms = gameRoomService;

  gameTypeService.setService(this);
  this.gameTypes = gameTypeService;

  userService.setService(this);
  this.users = userService;

  transportService.setService(this);
  this.transport = transportService;
}

module.exports = TbsService;
