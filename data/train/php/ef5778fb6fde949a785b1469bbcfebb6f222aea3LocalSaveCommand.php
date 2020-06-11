<?php

namespace RevyWeather\Console\Commands;

/**
 * Local save json to database
 * @author  Derek Marcinyshyn
 * @date    2016-03-27
 */

use GuzzleHttp\Client;
use Illuminate\Console\Command;
use RevyWeather\Services\Log\Daily;
use RevyWeather\Services\Weather\SaveLocal;

class LocalSaveCommand extends Command
{
    /**
     * @var string
     */
    protected $signature = 'revyweather:local-save';

    /**
     * @var string
     */
    protected $description = 'Get local weather and save to database';

    /**
     * LocalSaveCommand constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @param SaveLocal $saveLocal
     * @param Client $client
     * @param Daily $daily
     */
    public function handle(SaveLocal $saveLocal, Client $client, Daily $daily)
    {
        $this->comment('Getting local weather');
        $saveLocal->getWeather($client, $daily);
        $this->info('done.');
    }
}
