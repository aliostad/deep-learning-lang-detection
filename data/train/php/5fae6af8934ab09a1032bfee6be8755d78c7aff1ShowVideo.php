<?php namespace app\models;

use \Yii;
use \yii\db\ActiveRecord;

/**
 * This is the model class tv show videos.
 *
 * @property string $id
 * @property integer $show_id
 * @property string $key
 * @property string $name
 * @property string $site
 * @property integer $size
 * @property string $type
 *
 * @property Show $show
 */
class ShowVideo extends ActiveRecord
{
	/**
	 * @inheritdoc
	 */
	public static function tableName()
	{
		return '{{%show_video}}';
	}

	/**
	 * @inheritdoc
	 */
	public function rules()
	{
		return [
			[['id', 'show_id'], 'required'],
			[['show_id', 'size'], 'integer'],
			[['id'], 'string', 'max' => 32],
			[['key', 'name'], 'string', 'max' => 255],
			[['site'], 'string', 'max' => 127],
			[['type'], 'string', 'max' => 31]
		];
	}

	/**
	 * @inheritdoc
	 */
	public function attributeLabels()
	{
		return [
			'id' => Yii::t('Show/Video', 'Video ID'),
			'show_id' => Yii::t('Show/Video', 'Show'),
			'key' => Yii::t('Show/Video', 'Key'),
			'name' => Yii::t('Show/Video', 'Name'),
			'site' => Yii::t('Show/Video', 'Site'),
			'size' => Yii::t('Show/Video', 'Size'),
			'type' => Yii::t('Show/Video', 'Type'),
		];
	}

	/**
	 * @return \yii\db\ActiveQuery
	 */
	public function getShow()
	{
		return $this->hasOne(Show::className(), ['id' => 'show_id']);
	}
}
