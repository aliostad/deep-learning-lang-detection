<?php

return array(
    'parameters'    => array(
        'monolog.logger.class'                  => 'PPI\MonologModule\Logger',
        'monolog.gelf.publisher.class'          => 'Gelf\MessagePublisher',
        'monolog.handler.stream.class'          => 'Monolog\Handler\StreamHandler',
        'monolog.handler.console.class'         => 'Symfony\Bridge\Monolog\Handler\ConsoleHandler',
        'monolog.handler.group.class'           => 'Monolog\Handler\GroupHandler',
        'monolog.handler.buffer.class'          => 'Monolog\Handler\BufferHandler',
        'monolog.handler.rotating_file.class'   => 'Monolog\Handler\RotatingFileHandler',
        'monolog.handler.syslog.class'          => 'Monolog\Handler\SyslogHandler',
        'monolog.handler.syslogudp.class'       => 'Monolog\Handler\SyslogUdpHandler',
        'monolog.handler.null.class'            => 'Monolog\Handler\NullHandler',
        'monolog.handler.test.class'            => 'Monolog\Handler\TestHandler',
        'monolog.handler.gelf.class'            => 'Monolog\Handler\GelfHandler',
        'monolog.handler.firephp.class'         => 'Symfony\Bridge\Monolog\Handler\FirePHPHandler',
        'monolog.handler.chromephp.class'       => 'Symfony\Bridge\Monolog\Handler\ChromePhpHandler',
        'monolog.handler.debug.class'           => 'Symfony\Bridge\Monolog\Handler\DebugHandler',
        'monolog.handler.swift_mailer.class'    => 'Symfony\Bridge\Monolog\Handler\SwiftMailerHandler',
        'monolog.handler.native_mailer.class'   => 'Monolog\Handler\NativeMailerHandler',
        'monolog.handler.socket.class'          => 'Monolog\Handler\SocketHandler',
        'monolog.handler.pushover.class'        => 'Monolog\Handler\PushoverHandler',
        'monolog.handler.raven.class'           => 'Monolog\Handler\RavenHandler',
        'monolog.handler.newrelic.class'        => 'Monolog\Handler\NewRelicHandler',
        'monolog.handler.hipchat.class'         => 'Monolog\Handler\HipChatHandler',
        'monolog.handler.cube.class'            => 'Monolog\Handler\CubeHandler',
        'monolog.handler.amqp.class'            => 'Monolog\Handler\AmqpHandler',
        'monolog.handler.error_log.class'       => 'Monolog\Handler\ErrorLogHandler',
        'monolog.handler.loggly.class'          => 'Monolog\Handler\LogglyHandler',
        'monolog.handler.logentries.class'      => 'Monolog\Handler\LogEntriesHandler',
        'monolog.activation_strategy.not_found.class'
        => 'Symfony\Bundle\MonologBundle\NotFoundActivationStrategy',
        'monolog.handler.fingers_crossed.class' => 'Monolog\Handler\FingersCrossedHandler',
        'monolog.handler.fingers_crossed.error_level_activation_strategy.class'
        => 'Monolog\Handler\FingersCrossed\ErrorLevelActivationStrategy',
        'monolog.handler.mongo.class'           => 'Monolog\Handler\MongoDBHandler',
        'monolog.mongo.client.class'            => 'MongoClient'
    )
);
