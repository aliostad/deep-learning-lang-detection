/**
 * @file HandlerFactory.hpp
 * @author Steven GERARD
 */
#ifndef HANDLER_FACTORY_HPP
#define HANDLER_FACTORY_HPP

#include "../Handler.hpp"
#include "../../Tools/Data.hpp"

/**
 * @class HandlerFactory
 * @brief Interface for the handler factories 
 */
class HandlerFactory
{
	public:
		/**
		 * @brief Virtual methode to create handler.
		 * 
		 * @param type Direction chose by users
		 * @return New handler
		 */
		virtual Handler* makeHandler(WindDirection type)=0;

		/**
		 * @brief Detlete the handler.
		 * 
		 * @param h Handler delete.
		 */
		virtual void deleteHandler(Handler* h)=0;
};

#endif