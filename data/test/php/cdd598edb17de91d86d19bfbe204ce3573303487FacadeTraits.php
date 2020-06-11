<?php

namespace Core\Services\Facade;

use Core\Helpers\Config;

trait FacadeTraits {

    /**
     * Init Facades.
     *
     * @param string $configFile
     */
    private function initFacades(string $configFile) {

        // Read Config file - section Facades
        $facadesArray = Config::readConfig($configFile, 'facades');

        // Move every class and init them
        foreach ($facadesArray as $facadeClass) {
            if (class_exists($facadeClass)) {
                call_user_func([$facadeClass, 'init'], $this);
            }
        }
    }
}
