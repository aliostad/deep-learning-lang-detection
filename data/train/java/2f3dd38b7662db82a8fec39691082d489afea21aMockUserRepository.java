package com.decisionmaker.repository.user;

import org.hibernate.SessionFactory;

import com.decisionmaker.repository.message.IMessageRepository;
import com.decisionmaker.repository.user.UserRepository;

public class MockUserRepository extends UserRepository {

	public void setMessageRepository(IMessageRepository messageRepository) {
		this.messageRepository = messageRepository;
	}
	
	public void setFriendRepository(IFriendshipRepository friendshipRepository) {
		this.friendshipRepository = friendshipRepository;
	}
	
	@Override
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

}
