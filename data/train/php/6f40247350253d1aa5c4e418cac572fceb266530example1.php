<?php
include __DIR__ . '/../vendor/autoload.php';

use NetService\Service,
    NetService\Parser;

$host        = 'windowshost.com';
$serviceName = 'ServiceName';
$credentials = '{domain}/{user}%{password}';

$service = new Service(new Parser($host, $credentials));

if ($service->isRunning($serviceName)) {
    echo "Service is running. Let's stop";
    $service->stop($serviceName);

} else {
    echo "Service isn't running. Let's start";
    $service->start($serviceName);
}

//dumps status output
echo $service->status($serviceName);