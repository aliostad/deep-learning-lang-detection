#ifndef EPOLL_HANDLER_MGR_H_
#define EPOLL_HANDLER_MGR_H_

#include <map>
#include "singleton.h"
#include "epoll_handler.h" 

class epoll_handler_mgr : public singleton<epoll_handler_mgr>
{
public:
	epoll_handler_mgr();
	epoll_handler*  find(const int sock_id);
	int insert(epoll_handler *handler);
	void del(const int sock_id);
private:
	typedef std::map<int /*sock_id*/, epoll_handler *> handler_map;
	typedef std::map<int /*sock_id*/, epoll_handler *>::iterator handler_map_iter;
	handler_map handler_map_;
};

#endif
