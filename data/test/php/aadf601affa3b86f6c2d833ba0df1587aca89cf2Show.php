<?php

namespace app\models;

use Yii;
use yii\base\Model;
use yii\db\ActiveRecord;
use yii\db\Query;

class Show extends ActiveRecord {

    public function getty() {
        return Show::find()->orderBy('menu_order')->all();
    }

    public function getById($ider)
    {
        return (new Query())
            ->select(['*'])
            ->from('show')
            ->where(['show_categ' => $ider])
            ->all();
    }

    public function inserter($i, $j) {
        return Yii::$app->db->createCommand()->insert('show', ['show_city' => $i, 'show_categ' => $j, 'show_is' => '1'])->execute();
    }

public function addNewCat($ider, $maxer) {
    return Yii::$app->db->createCommand()->insert('show', ['show_city' => $ider, 'show_categ' => $maxer, 'show_is' => '1'])->execute();
}

    public function updater($id, $city, $show) {
        $item = Show::findOne(['show_categ' => $id, 'show_city' => $city]);
        $item->show_is = $show;
        return $item->update();
    }

    public function deleter($arr) {
        return Yii::$app->db->createCommand()->delete('show', ['show_categ' => $arr['ider']])
            ->execute();
    }

     public function delplace($place) {
        return Yii::$app->db->createCommand()->delete('show', ['show_city' => $place])
            ->execute();
    }


}