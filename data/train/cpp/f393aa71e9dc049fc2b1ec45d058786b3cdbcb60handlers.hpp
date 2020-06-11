/*
 *     SocialLedge.com - Copyright (C) 2013
 *
 *     This file is part of free software framework for embedded processors.
 *     You can use it and/or distribute it as long as this copyright header
 *     remains unmodified.  The code is free for personal use and requires
 *     permission to use in a commercial product.
 *
 *      THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 *      OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 *      MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 *      I SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
 *      CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 *
 *     You can reach the author of this software at :
 *          p r e e t . w i k i @ g m a i l . c o m
 */

/**
 * @file
 * @brief Contains the terminal handler function declarations.
 */
#ifndef HANDLERS_HPP_
#define HANDLERS_HPP_

#include "command_handler.hpp"



/// Handler for task list & CPU Information
CMD_HANDLER_FUNC(taskListHandler);

/// Handler to list memory information
CMD_HANDLER_FUNC(memInfoHandler);

/// Handler to get system health
CMD_HANDLER_FUNC(healthHandler);

/// Handler for Logger stuff
CMD_HANDLER_FUNC(logHandler);

/// Handler for setting and getting time
CMD_HANDLER_FUNC(timeHandler);

/// Handler to copy files within File System (SD & Flash)
CMD_HANDLER_FUNC(cpHandler);

/// Handler to read a file from Flash or SD Card
CMD_HANDLER_FUNC(catHandler);

/// Handler for "ls" linux style command
CMD_HANDLER_FUNC(lsHandler);

/// Handler to create a directory
CMD_HANDLER_FUNC(mkdirHandler);

/// Handler for "rm" to remove a file
CMD_HANDLER_FUNC(rmHandler);

/// Handler for I2C IO
CMD_HANDLER_FUNC(i2cIoHandler);

/// Handler to move/rename a file
CMD_HANDLER_FUNC(mvHandler);

/// Handler to create new file
CMD_HANDLER_FUNC(newFileHandler);

/// Copy directory files
CMD_HANDLER_FUNC(dcpHandler);

/// Handler to format and mount storage mediums
CMD_HANDLER_FUNC(storageHandler);

/// Handler to reboot the system
CMD_HANDLER_FUNC(rebootHandler);

/// Handler to get telemetry
CMD_HANDLER_FUNC(telemetryHandler);

/// Learn IR Code handler
CMD_HANDLER_FUNC(learnIrHandler);

/// Send a packet over the air
CMD_HANDLER_FUNC(wirelessHandler);



#endif /* HANDLERS_HPP_ */
