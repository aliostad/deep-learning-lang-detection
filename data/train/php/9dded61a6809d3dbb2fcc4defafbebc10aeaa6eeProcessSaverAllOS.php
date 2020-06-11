<?php

Namespace Model;

class ProcessSaverAllOS extends Base {

    // Compatibility
    public $os = array("any") ;
    public $linuxType = array("any") ;
    public $distros = array("any") ;
    public $versions = array("any") ;
    public $architectures = array("any") ;

    // Model Group
    public $modelGroup = array("ProcessSaver") ;

    public function saveProcess($save) {
        $r = $this->saveStates($save);
        return $r ;
    }

    public function getProcessNames() {
        $processes = $this->getProcesses() ;
        $names = array_keys($processes) ;
        return (isset($names) && is_array($names)) ? $names : false ;
    }

    private function saveStates($save) {
        $saveRes = array() ;
        $saveRes["defaults"] = $this->saveDefaults($save) ;
        $saveRes["settings"] = $this->saveSettings($save) ;
        $saveRes["steps"] = $this->saveSteps($save) ;
        return $saveRes ;
    }

    private function saveDefaults($save) {
        $loggingFactory = new \Model\Logging();
        $logging = $loggingFactory->getModel($this->params);
        if (isset($save["type"]) && $save["type"] == "Defaults") {
            $defaultsFile = PROCESSDIR.DS.$this->params["item"].DS.'defaults' ;
            $logging->log("Storing defaults file in pipe at $defaultsFile", $this->getModuleName()) ;
            $defaults = json_encode($save["data"]) ;
            return file_put_contents($defaultsFile, $defaults) ; }
        return false ;
    }

    private function saveSteps($save) {
        $loggingFactory = new \Model\Logging();
        $logging = $loggingFactory->getModel($this->params);
        if (isset($save["type"]) && $save["type"] == "Steps") {
            $stepsFile = PROCESSDIR.DS.$this->params["item"].DS.'steps' ;
            $logging->log("Storing steps file in pipe at $stepsFile", $this->getModuleName()) ;
            $steps = json_encode($save["data"]) ;
            return file_put_contents($stepsFile, $steps) ; }
        $statuses = array() ;
        return $statuses ;
    }

    private function saveSettings($save) {
        $loggingFactory = new \Model\Logging();
        $logging = $loggingFactory->getModel($this->params);
        if (isset($save["type"]) && $save["type"] == "Settings") {
            $stepsFile = PROCESSDIR.DS.$this->params["item"].DS.'settings' ;
            $logging->log("Storing settings file in pipe at $stepsFile", $this->getModuleName()) ;
            $steps = json_encode($save["data"]) ;
            return file_put_contents($stepsFile, $steps) ; }
        $statuses = array() ;
        return $statuses ;
    }

}