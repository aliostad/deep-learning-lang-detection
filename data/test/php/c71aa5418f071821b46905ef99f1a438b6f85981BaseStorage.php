<?php

namespace mdm\logger\storages;

/**
 * Description of DummyStorage
 *
 * @author Misbahul D Munir (mdmunir) <misbahuldmunir@gmail.com>
 */
class BaseStorage extends \yii\base\Object
{

    public function batchSave($name, $rows)
    {
        $this->doBatchSave($name, $rows);
    }

    public function save($name, $row)
    {
        $this->doSave($name, $row);
    }

    protected function doBatchSave($name, $rows)
    {
        \Yii::trace("Batch save to '{$name}'", __METHOD__);
        // dont do anything
    }

    protected function doSave($name, $row)
    {
        \Yii::trace("Save to '{$name}'", __METHOD__);
        // dont do anything
    }
}
