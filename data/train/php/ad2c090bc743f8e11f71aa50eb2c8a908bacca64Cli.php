<?php

namespace Wave\Log;

use Monolog\Formatter\LineFormatter;
use Monolog\Handler\AbstractHandler;
use Wave\Log;

class Cli extends Log {


    public static function createChannel($channel, AbstractHandler $handler = null) {

        $cli_handler = new CliHandler();
        $cli_handler->setFormatter(new LineFormatter(CliHandler::LINE_FORMAT));

        $channel_handler = parent::createChannel($channel, $handler);
        $channel_handler->pushHandler($cli_handler);

        static::setChannel($channel, $channel_handler);

        return $channel_handler;
    }

}
