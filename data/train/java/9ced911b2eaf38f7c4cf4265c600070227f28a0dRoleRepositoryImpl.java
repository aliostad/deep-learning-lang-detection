package hu.neuron.java.core.repository.imp;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import hu.neuron.java.core.entity.User;
import hu.neuron.java.core.repository.RoleRepository;
import hu.neuron.java.core.repository.RoleRepositoryCustom;
import hu.neuron.java.core.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;

public class RoleRepositoryImpl implements RoleRepositoryCustom {
	@Autowired
	UserRepository userRepository;

	@Autowired
	RoleRepository roleRepository;	

	@Override
	public void removeRoleFromUser(Long roleId, Long userId) throws Exception {
		User user = userRepository.findOne(userId);
		user.getRoles().remove(roleRepository.findOne(roleId));
		userRepository.save(user);
	}

}
