<?php

namespace lib;

class Model extends \SimpleORM\ORM {
    public function __construct()
    {
        $this->_adapter = App::getComponent('db');
        parent::__construct();
    }

    public function getClassName()
    {
        return preg_replace('/^models\\\(.*)$/', '$1', get_class($this));
    }

    public function beforeSave()
    {
        return true;
    }

    public function save()
    {
        if ($this->beforeSave()) {
            $ok = parent::save();
            $this->afterSave();
            return $ok;
        }
        return false;
    }

    public function afterSave()
    {
        return true;
    }

}