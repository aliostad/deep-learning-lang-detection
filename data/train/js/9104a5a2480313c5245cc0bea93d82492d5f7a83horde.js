angular
	.module('horde', [])
	.controller('incomingAttackPanelController',['$scope', 'resourceService', 'hordeService', 'featureLockService', function ($scope, resourceService, hordeService, featureLockService) {
		$scope.refresh = function () {
			$scope.attackProgress = hordeService.attackProgress;
			$scope.horde = hordeService.horde;
			$scope.defense = resourceService.defense;
			$scope.featureLockService = featureLockService;
		}
		$scope.refresh();
	}])
	.controller('threatPanelController',['$scope', 'resourceService', 'hordeService', 'featureLockService', function ($scope, resourceService, hordeService, featureLockService) {
		$scope.refresh = function () {
			$scope.horde = hordeService.horde;
			$scope.threat = resourceService.threat;
			$scope.featureLockService = featureLockService;
		}
		$scope.refresh();
	}])
	.service('hordeService', ['resourceService', 'infoService', function (resourceService, infoService) {
		var hordeService = this;
		this.attackProgress = {
			attackIn: 100
		}

		this.horde = {
			size: 0,
			nextZombieProgress: 0,
			percentFull: 0,
			text: "Zombies Gathering",
		}

		this.init = function () {
			this.attackProgress.attackIn = 100;
			this.horde.size = 0;
			this.horde.nextZombieProgress = 0;
			this.horde.percentFull = this.horde.nextZombieProgress; // 50 * 100;
		}

		this.tick = function () {
			processThreat();
			advanceAttack();
		}

		function processThreat () {
			var threat = resourceService.threat.totalChangePerSecond;
			hordeService.horde.nextZombieProgress += threat;
			if (hordeService.horde.nextZombieProgress > 100) {
				hordeService.horde.size += 1;
				hordeService.horde.nextZombieProgress = 0;
			} else if (hordeService.horde.nextZombieProgress < 0) {
				if (hordeService.horde.size > 0) {
					hordeService.horde.nextZombieProgress = 100;
					hordeService.horde.size -= 1;
				} else {
					hordeService.horde.nextZombieProgress = 0;
				}
			}
			hordeService.horde.percentFull = hordeService.horde.nextZombieProgress;///50*100

		}

		function advanceAttack () {
			hordeService.attackProgress.attackIn -= 1;
			if (hordeService.attackProgress.attackIn <= 0) {
				hordeService.attackProgress.attackIn = 100;
				launchAttack();
			}
		}

		function launchAttack () {
			if (hordeService.horde.size > resourceService.defense.count) {
				infoService.setMessage("Zombies attacked: you lost!");
			} else {
				infoService.setMessage("Zombies attacked: you won!");
			}
			hordeService.horde.size = 0;
			hordeService.horde.nextZombieProgress = 0;
		}

	}])