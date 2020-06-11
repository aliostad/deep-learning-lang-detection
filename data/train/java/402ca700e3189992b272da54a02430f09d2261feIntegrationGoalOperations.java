package com.clemble.casino.integration.goal;

import com.clemble.casino.client.goal.GoalOperations;
import com.clemble.casino.goal.configuration.controller.GoalConfigurationServiceController;
import com.clemble.casino.goal.controller.GoalActionServiceController;
import com.clemble.casino.goal.controller.GoalRecordServiceController;
import com.clemble.casino.goal.controller.GoalVictoryServiceController;
import com.clemble.casino.goal.lifecycle.configuration.service.GoalConfigurationService;
import com.clemble.casino.goal.construction.controller.GoalConstructionServiceController;
import com.clemble.casino.goal.construction.controller.GoalInitiationServiceController;
import com.clemble.casino.goal.lifecycle.construction.service.GoalConstructionService;
import com.clemble.casino.goal.lifecycle.construction.service.GoalSuggestionService;
import com.clemble.casino.goal.lifecycle.initiation.service.GoalInitiationService;
import com.clemble.casino.goal.lifecycle.management.service.GoalActionService;
import com.clemble.casino.goal.lifecycle.management.service.GoalVictoryService;
import com.clemble.casino.goal.lifecycle.record.service.GoalRecordService;
import com.clemble.casino.goal.suggestion.controller.GoalSuggestionServiceController;

/**
 * Created by mavarazy on 9/15/14.
 */
public class IntegrationGoalOperations implements GoalOperations {

    final private GoalConfigurationService configurationService;
    final private GoalConstructionService constructionService;
    final private GoalSuggestionService suggestionService;
    final private GoalRecordService recordService;
    final private GoalInitiationService initiationService;
    final private GoalActionService actionService;
    final private GoalVictoryService victoryService;

    public IntegrationGoalOperations(String player,
        GoalConfigurationServiceController configurationService,
        GoalInitiationServiceController initiationService,
        GoalSuggestionServiceController suggestionService,
        GoalConstructionServiceController constructionService,
        GoalActionServiceController actionService,
        GoalRecordServiceController recordService,
        GoalVictoryServiceController victoryService) {
        this.recordService = new IntegrationGoalRecordService(player, recordService);
        this.configurationService = new IntegrationGoalConfigurationService(player, configurationService);
        this.suggestionService = new IntegrationGoalSuggestionService(player, suggestionService);
        this.initiationService = new IntegrationGoalInitiationService(player, initiationService);
        this.constructionService = new IntegrationGoalConstructionService(player, constructionService);
        this.actionService = new IntegrationGoalActionService(player, actionService);
        this.victoryService = new IntegrationGoalVictoryService(player, victoryService);
    }

    @Override
    public GoalConfigurationService configurationService() {
        return configurationService;
    }

    @Override
    public GoalConstructionService constructionService() {
        return constructionService;
    }

    @Override
    public GoalSuggestionService suggestionService() {
        return suggestionService;
    }

    @Override
    public GoalInitiationService initiationService() {
        return initiationService;
    }

    @Override
    public GoalActionService actionService() {
        return actionService;
    }

    @Override
    public GoalRecordService recordService() {
        return recordService;
    }

    @Override
    public GoalVictoryService victoryService() {
        return victoryService;
    }

}
