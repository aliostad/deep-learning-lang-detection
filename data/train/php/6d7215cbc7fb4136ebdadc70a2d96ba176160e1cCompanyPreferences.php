<?php

/**
 * This is the model class for table "company_preferences".
 *
 * The followings are the available columns in table 'company_preferences':
 * @property integer $company_preferences_id
 * @property integer $company_id
 * @property string $show_companyname
 * @property string $show_address
 * @property string $show_comments
 * @property string $show_business_phone
 * @property string $show_phone
 * @property string $show_title
 * @property string $show_education
 * @property string $show_career
 * @property string $show_positionlevel
 * @property string $show_keyposition
 * @property string $show_candidatecomments
 */
class CompanyPreferences extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'company_preferences';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('company_id', 'numerical', 'integerOnly'=>true),
			array('show_companyname, show_address, show_comments, show_business_phone, show_phone, show_title, show_education, show_career, show_positionlevel, show_keyposition, show_candidatecomments', 'length', 'max'=>45),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('company_preferences_id, company_id, show_companyname, show_address, show_comments, show_business_phone, show_phone, show_title, show_education, show_career, show_positionlevel, show_keyposition, show_candidatecomments', 'safe', 'on'=>'search'),
		);
	}

	/**
	 * @return array relational rules.
	 */
	public function relations()
	{
		// NOTE: you may need to adjust the relation name and the related
		// class name for the relations automatically generated below.
		return array(
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'company_preferences_id' => 'Company Preferences',
			'company_id' => 'Company',
			'show_companyname' => 'Show Companyname',
			'show_address' => 'Show Address',
			'show_comments' => 'Show Comments',
			'show_business_phone' => 'Show Business Phone',
			'show_phone' => 'Show Phone',
			'show_title' => 'Show Title',
			'show_education' => 'Show Education',
			'show_career' => 'Show Career',
			'show_positionlevel' => 'Show Positionlevel',
			'show_keyposition' => 'Show Keyposition',
			'show_candidatecomments' => 'Show Candidatecomments',
		);
	}

	/**
	 * Retrieves a list of models based on the current search/filter conditions.
	 *
	 * Typical usecase:
	 * - Initialize the model fields with values from filter form.
	 * - Execute this method to get CActiveDataProvider instance which will filter
	 * models according to data in model fields.
	 * - Pass data provider to CGridView, CListView or any similar widget.
	 *
	 * @return CActiveDataProvider the data provider that can return the models
	 * based on the search/filter conditions.
	 */
	public function search()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('company_preferences_id',$this->company_preferences_id);
		$criteria->compare('company_id',$this->company_id);
		$criteria->compare('show_companyname',$this->show_companyname,true);
		$criteria->compare('show_address',$this->show_address,true);
		$criteria->compare('show_comments',$this->show_comments,true);
		$criteria->compare('show_business_phone',$this->show_business_phone,true);
		$criteria->compare('show_phone',$this->show_phone,true);
		$criteria->compare('show_title',$this->show_title,true);
		$criteria->compare('show_education',$this->show_education,true);
		$criteria->compare('show_career',$this->show_career,true);
		$criteria->compare('show_positionlevel',$this->show_positionlevel,true);
		$criteria->compare('show_keyposition',$this->show_keyposition,true);
		$criteria->compare('show_candidatecomments',$this->show_candidatecomments,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CompanyPreferences the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
