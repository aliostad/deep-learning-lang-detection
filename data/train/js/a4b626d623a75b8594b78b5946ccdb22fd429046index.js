/* global setTimeout */
'use strict';

var util = require('./util');
var _ = require('lodash');
var iconFilenameMappings = require('./icon-filename-mapping');
var nameMappingPl = require('./nameMappingPl');
var apiHelperFactory = require('./apiHelper');
var eraService = require('./common/EraService');

var createService = function(userData) {
	var paused = false;
	var apiHelper = apiHelperFactory.get(userData);

	const wls = util.writeLogService(userData);

	let afterStartGameCallback = (result) => {
		userData.worldObj = result.world;
		userData.worldName = userData.worldObj.name;
		return invokeGetData();
	};

	const serviceArray = [];

	const definitionService = require('./server/DefinitionService').get(userData); serviceArray.push(definitionService);
	const apiService = require('./server/ApiService').get(userData, apiHelper, afterStartGameCallback);// serviceArray.push(apiService);
	const staticDataService = require('./server/StaticDataService').get(userData, apiHelper); serviceArray.push(staticDataService);
	const resourceService = require('./server/ResourceService').get(userData, apiService, definitionService); serviceArray.push(resourceService);
	const cityResourcesService = require('./server/CityResourcesService').get(userData, apiService, resourceService); serviceArray.push(cityResourcesService);
	const cityMapService = require('./server/CityMapService').get(userData, definitionService, cityResourcesService, apiService); serviceArray.push(cityMapService);
	const treasureHuntService = require('./server/TreasureHuntService').get(userData, apiService); serviceArray.push(treasureHuntService);
	const otherPlayerService = require('./server/OtherPlayerService').get(userData, apiService, definitionService); serviceArray.push(otherPlayerService);
	const cityProductionService = require('./server/CityProductionService').get(userData, apiService, cityMapService, definitionService, cityResourcesService); serviceArray.push(cityProductionService);
	const researchService = require('./server/ResearchService').get(userData, apiService, cityResourcesService); serviceArray.push(researchService);
	const friendsTavernService = require('./server/FriendsTavernService').get(userData, apiService, otherPlayerService, resourceService, researchService); serviceArray.push(friendsTavernService, researchService);
	const friendService = require('./server/FriendService').get(userData, apiService, otherPlayerService); serviceArray.push(friendService);
	const hiddenRewardService = require('./server/HiddenRewardService').get(userData, apiService); serviceArray.push(hiddenRewardService);
	const startupService = require('./server/StartupService').get(userData, apiService, cityMapService, definitionService, cityResourcesService, resourceService); serviceArray.push(startupService);
	const campaignService = require('./server/CampaignService').get(userData, apiService, cityResourcesService, eraService); serviceArray.push(campaignService);
	const greatBuildingsService = require('./server/GreatBuildingsService').get(userData, apiService, definitionService, cityResourcesService, cityMapService, otherPlayerService); serviceArray.push(greatBuildingsService);
	const tradeService = require('./server/TradeService').get(userData, apiService, definitionService, cityResourcesService, eraService, campaignService); serviceArray.push(tradeService);

	apiService.setServiceArray(serviceArray);

	var startAccount = function() {
		return apiHelper.startAccount(userData).then(result => {
			if (result && result.status && result.status === 'ACCOUNT_STARTED') {
				return afterStartGameCallback(result);
			}
			return result;
		});
	};

	var isLogged = false;
	var user_data = null;

	var timeoutInterval = 5;
	var setAutoTimeout = function() {
		setTimeout(timeoutFunction, timeoutInterval * 1000);
	};
	var timeoutFunction = function() {
		if (isLogged && !paused) {
			processAutomaticActions().then(() => {
				setAutoTimeout();
			}, (reason) => {
				wls.writeLog('Automatyczne przetwarzanie zgłosiło wyjątek');
				if (reason instanceof Error) {
					wls.writeLog(reason.stack);
				} else {
					wls.writeLog(reason);
				}
				setAutoTimeout();
			});
			return;
		}
		setAutoTimeout();
	};
	setAutoTimeout();

	var invokeGetData = function() {
		wls.writeLog('Wywołanie invokeGetData');
		return startupService.getData().then(result => {
			user_data = result.user_data;
			userData.era = user_data.era.era;
			userData.eraName = eraService.getEraName(user_data.era.era);
			isLogged = true;
			return staticDataService.retrieveMetaData('city_entities').then(bldDefArray => {
				definitionService.setBuildingDefinitions(bldDefArray);
				return result;
			});
		});
	};

	var deleteBuilding = (query) => {
		return cityMapService.removeBuilding(query.bldId).then(() => ({status: 'OK'}));
	};

	var processAutomaticActions = function() {
		return util.getEmptyPromise({})
			.then(cityProductionService.process)
			.then(otherPlayerService.process)
			.then(hiddenRewardService.process)
			.then(researchService.process)
			.then(greatBuildingsService.process)
			.then(tradeService.process)
			.then(campaignService.process)
			.then(cityMapService.process)
			.then(resourceService.process)
			.then(treasureHuntService.process)
			.then(friendsTavernService.process)
			.then(cityResourcesService.process);
	};


	var resumeAccount = function() {
		wls.writeLog('Wyłączam pauzę');
		paused = false;
		return util.getEmptyPromise({
			status: 'OK'
		});
	};

	var pauseAccount = function() {
		wls.writeLog('Włączam pauzę');
		paused = true;
		return util.getEmptyPromise({
			status: 'OK'
		});
	};

	var getBasePath = () => {
		return apiHelper.getBasePath();
	};

	var getDefinitions = function() {
		if (!userData) {
			return util.getEmptyPromise({});
		}
		return util.getEmptyPromise({
			city_entities: definitionService.getDefinitions().buildings,
			resDefinitions: definitionService.getDefinitions().resources,
			basePath: getBasePath(),
			iconFilenameMappings: iconFilenameMappings.data,
			nameMappingPl: nameMappingPl.data
		});
	};

	var getAccountData = function() {
		if (!userData) {
			return util.getEmptyPromise({});
		}
		return util.getEmptyPromise({
			buildingList: cityMapService.getBuildingList(),
			resourceList: cityResourcesService.getResourceListUnion(),
			settings: userData.settings || {},
			paused: paused,
			researchArray: researchService.getResearchArray(),
			user_data: user_data,
			neighbourList: otherPlayerService.getNeighborList(),
			tradeOffersArray: tradeService.getMyOffers(true),
			otherOffersArray: tradeService.getMyOffers(false),
			campaign: campaignService.getCampaignData(),
			depositStates: campaignService.getDepositStates(),
			acceptedTrades: otherPlayerService.getAcceptedTrades(),
			world: userData.worldObj,
			tavernData: friendsTavernService.getData()
		});
	};

	var setProduction = function(setting) {
		if (!userData.settings) {
			userData.settings = {};
		}
		userData.settings[setting.id] = setting.production_id;
		return util.getEmptyPromise(userData.settings);
	};

	return {
		startAccount: startAccount,
		pauseAccount: pauseAccount,
		resumeAccount: resumeAccount,
		getDefinitions: getDefinitions,
		getAccountData: getAccountData,
		setProduction: setProduction,
		deleteBuilding: deleteBuilding
	};
};

exports.get = createService;
