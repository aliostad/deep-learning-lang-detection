<?php

namespace app\models;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Customer;

/**
 * CustomerSearch represents the model behind the search form about `app\models\Customer`.
 */
class CustomerSearch extends Customer
{
    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['customer_id', 'customer_poscode'], 'integer'],
            [['customer_name', 'customer_add1', 'customer_add2', 'customer_add3', 'customer_tel', 'customer_fax', 'customer_email', 'customer_type', 'customer_remark', 'customer_attention', 'customer_active', 'customer_GSTno'], 'safe'],
        ];
    }

    /**
     * @inheritdoc
     */
    public function scenarios()
    {
        // bypass scenarios() implementation in the parent class
        return Model::scenarios();
    }

    /**
     * Creates data provider instance with search query applied
     *
     * @param array $params
     *
     * @return ActiveDataProvider
     */
    public function search_customer($params)
    {
        $query = Customer::find();

        $dataProvider = new ActiveDataProvider([
            'query' => $query,
        ]);

        $this->load($params);

        if (!$this->validate()) {
            // uncomment the following line if you do not want to return any records when validation fails
            // $query->where('0=1');
            return $dataProvider;
        }

        $query->andFilterWhere([
            'customer_id' => $this->customer_id,
            'customer_poscode' => $this->customer_poscode,
        ]);

        $query->andFilterWhere(['like', 'customer_name', $this->customer_name])
            ->andFilterWhere(['like', 'customer_add1', $this->customer_add1])
            ->andFilterWhere(['like', 'customer_add2', $this->customer_add2])
            ->andFilterWhere(['like', 'customer_add3', $this->customer_add3])
            ->andFilterWhere(['like', 'customer_tel', $this->customer_tel])
            ->andFilterWhere(['like', 'customer_fax', $this->customer_fax])
            ->andFilterWhere(['like', 'customer_email', $this->customer_email])
            ->andFilterWhere(['like', 'customer_type', $this->customer_type])
            ->andFilterWhere(['like', 'customer_remark', $this->customer_remark])
            ->andFilterWhere(['like', 'customer_attention', $this->customer_attention])
            ->andFilterWhere(['like', 'customer_active', $this->customer_active])
            ->andFilterWhere(['like', 'customer_GSTno', $this->customer_GSTno]);

        return $dataProvider;
    }
	
	 public function search_supplier($params)
    {
        $query = Customer::find()->where(['customer_type' => 'S']);

        $dataProvider = new ActiveDataProvider([
            'query' => $query,
        ]);

        $this->load($params);

        if (!$this->validate()) {
            // uncomment the following line if you do not want to return any records when validation fails
            // $query->where('0=1');
            return $dataProvider;
        }

        $query->andFilterWhere([
            'customer_id' => $this->customer_id,
            'customer_poscode' => $this->customer_poscode,
        ]);

        $query->andFilterWhere(['like', 'customer_name', $this->customer_name])
            ->andFilterWhere(['like', 'customer_add1', $this->customer_add1])
            ->andFilterWhere(['like', 'customer_add2', $this->customer_add2])
            ->andFilterWhere(['like', 'customer_add3', $this->customer_add3])
            ->andFilterWhere(['like', 'customer_tel', $this->customer_tel])
            ->andFilterWhere(['like', 'customer_fax', $this->customer_fax])
            ->andFilterWhere(['like', 'customer_email', $this->customer_email])
            ->andFilterWhere(['like', 'customer_type', $this->customer_type])
            ->andFilterWhere(['like', 'customer_remark', $this->customer_remark])
            ->andFilterWhere(['like', 'customer_attention', $this->customer_attention])
            ->andFilterWhere(['like', 'customer_active', $this->customer_active])
            ->andFilterWhere(['like', 'customer_GSTno', $this->customer_GSTno]);

        return $dataProvider;
    }
}
