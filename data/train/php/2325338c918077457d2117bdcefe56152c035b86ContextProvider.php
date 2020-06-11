<?php

namespace Adrotec\BreezeJs\Save;

abstract class ContextProvider {

    public function saveChanges($saveBundle) {

//        $saveOptions = new SaveOptions($saveBundle->saveOptions);
        $entitiesMap = $saveBundle->entities;
        $saveWorkstate = new SaveWorkState($this, $entitiesMap);

        try {
            $saveWorkstate->beforeSave();
            $this->saveChangesCore($saveWorkstate);
            $saveWorkstate->afterSave();
//        } catch (EntityErrorsException $e) {
//            $saveWorkstate->entityErrors = $e->entityErrors;
        } 
        catch (\Exception $e) {
            if (!$this->handleSaveException($e, $saveWorkstate)) {
                throw new \RuntimeException($e);
            }
        }

        $saveResult = $saveWorkstate->toSaveResult();
        return $saveResult;
    }

    public function beforeSaveEntity(EntityInfo $entityInfo) {
        return true;
    }

    public function beforeSaveEntities($saveMap) {
        return $saveMap;
    }

    public function afterSaveEntities($saveMap, $keyMappings) {
        
    }

    protected function handleSaveException(\Exception $e, SaveWorkState $saveWorkState) {
        return false;
    }

    abstract protected function saveChangesCore(SaveWorkState $sw);
}
