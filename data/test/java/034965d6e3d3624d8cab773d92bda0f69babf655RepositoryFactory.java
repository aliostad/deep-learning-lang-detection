package com.teamdev.chat.factory;

import com.teamdev.chat.repository.*;

public class RepositoryFactory {
    private static ChatRoomRepository chatRoomRepository = new ChatRoomRepositoryImpl();
    private static MessageRepository messageRepository = new MessageRepositoryImpl();
    private static UserRepository userRepository = new UserRepositoryImpl();

    public static ChatRoomRepository getChatRoomRepository() {
        return chatRoomRepository;
    }

    public static MessageRepository getMessageRepository() {
        return messageRepository;
    }

    public static UserRepository getUserRepository() {
        return userRepository;
    }
}
