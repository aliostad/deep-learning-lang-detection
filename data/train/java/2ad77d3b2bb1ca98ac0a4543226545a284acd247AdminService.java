package de.caffeine.kitty.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import de.caffeine.kitty.service.repository.account.AccountRepository;
import de.caffeine.kitty.service.repository.consumtion.ConsumptionRepository;
import de.caffeine.kitty.service.repository.kitty.KittyRepository;
import de.caffeine.kitty.service.repository.user.UserRepository;

@Service
public class AdminService {
	
	@Autowired
	private UserRepository userRepository;
	@Autowired
	private KittyRepository kittyRepository;
	@Autowired
	private AccountRepository accountRepository;
	@Autowired
	private ConsumptionRepository consumptionRepository;
	
	public void reset() {
		userRepository.deleteAll();
		kittyRepository.deleteAll();
		accountRepository.deleteAll();
		consumptionRepository.deleteAll();
	}

}
