/*
 * system_event_handler_repository.h
 *
 *  Created on: Oct 2, 2014
 *      Author: hearthewarsong
 */

#ifndef SYSTEM_EVENT_HANDLER_REPOSITORY_H_
#define SYSTEM_EVENT_HANDLER_REPOSITORY_H_

class SystemEventHandlerRepository : public Singleton<SystemEventHandlerRepository>
{
public:
	SystemEventHandlerRepository();
	void AddSystemEventHandler(SystemEventHandler* seh);
	void RemoveSystemEventHandler(SystemEventHandler* seh);
	void GetSystemEventHandler(const char* name);
	void GetSystemEventHandler(const string& name);
	virtual ~SystemEventHandlerRepository();
};

#endif /* SYSTEM_EVENT_HANDLER_REPOSITORY_H_ */
