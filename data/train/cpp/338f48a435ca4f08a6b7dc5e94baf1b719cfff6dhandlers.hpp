#ifndef HANDLERS_HPP_
#define HANDLERS_HPP_

#include "CommandHandler.hpp"

/// Handler for task list & CPU Information
CMD_HANDLER_FUNC(taskListHandler);

/// Handler to list memory information
CMD_HANDLER_FUNC(memInfoHandler);

/// Handler for Logger Class Test & Sample
CMD_HANDLER_FUNC(loggerTest);

/// Handler for setting and getting time
CMD_HANDLER_FUNC(timeHandler);

/// Handler to copy files within File System (SD & Flash)
CMD_HANDLER_FUNC(copyHandler);

/// Handler to read a file from Flash or SD Card
CMD_HANDLER_FUNC(readHandler);

/// Handler for "ls" linux style command
CMD_HANDLER_FUNC(lsHandler);

/// Handler for "rm" to remove a file
CMD_HANDLER_FUNC(rmHandler);

#endif /* HANDLERS_HPP_ */
