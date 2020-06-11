package com.gottmusig.database.service.domain.jpa;

import com.gottmusig.database.service.domain.GottMusIg;
import com.gottmusig.database.service.domain.account.AccountService;
import com.gottmusig.database.service.domain.character.CharacterService;
import com.gottmusig.database.service.domain.dpsdifference.DPSDifferenceService;
import com.gottmusig.database.service.domain.item.ItemService;
import com.gottmusig.database.service.domain.realm.RealmService;
import com.gottmusig.database.service.domain.simulation.SimulationService;

/**
 * Description
 *
 * @author lgottschick
 * @since 1.0.0-SNAPSHOT
 */
public class GottMusIgImpl implements GottMusIg {

	private final RealmService realmService;
	private final ItemService itemService;
	private final AccountService accountService;
	private final CharacterService characterService;
	private final SimulationService simulationService;
	private final DPSDifferenceService dpsDifferenceService;

	public GottMusIgImpl(RealmService realmService,
						 ItemService itemService,
						 AccountService accountService,
						 CharacterService characterService,
						 SimulationService simulationService,
						 DPSDifferenceService dpsDifferenceService) {
		this.realmService = realmService;
		this.itemService = itemService;
		this.accountService = accountService;
		this.characterService = characterService;
		this.simulationService = simulationService;
		this.dpsDifferenceService = dpsDifferenceService;
	}
	
    @Override
    public RealmService realmService() {
        return realmService;
    }

    @Override
    public ItemService itemService() {
        return itemService;
    }

    @Override
    public AccountService accountService() {
        return accountService;
    }

    @Override
    public CharacterService characterService() {
        return characterService;
    }

    @Override
    public SimulationService simulationService() {
        return simulationService;
    }

    @Override
    public DPSDifferenceService dpsDifferenceService() {
        return dpsDifferenceService;
    }
}
