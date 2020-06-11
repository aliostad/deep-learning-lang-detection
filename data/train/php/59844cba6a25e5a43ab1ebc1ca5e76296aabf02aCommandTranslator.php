<?php namespace Firemango\BusDriver\Command;

    class CommandTranslator {

        /**
         * Get Handler
         *
         * Returns the name of the associated Handler for a Command object.
         *
         * @param $command
         * @return string
         * @throws HandlerNotFoundException
         */
        public function getHandler($command)
        {
            $handler = get_class($command) . "Handler";

            if ( ! class_exists($handler)) {
                throw new HandlerNotFoundException("Command Handler [{$handler}], does not exist.");
            }

            return $handler;
        }

    }