#pragma once
#include "ChatRepository.h"
#include <exception>

class MyException : public std::exception {
private:
	std::string error;
public:
	MyException(std::string error) : error(error) {}
	std::string what() { return error; }
};

class Chat
{
public:
	Chat();
	//Chat(ChatRepository repo) : repo(repo) {}
	Chat(ChatRepository* repo) : repo(repo) {}
	~Chat();
	ChatRepository* getRepo() { return repo; }
	void addMessage(Message m);
	//std::vector<Window*> guis;
private:
	ChatRepository* repo;
	User fromStringToUser(std::string exp);
	Message fromStringToMessage(std::string exp);

};

