<?php
class RegisterForm extends  CFormModel
{
    public $customer_email;
    public $customer_pwd;
    public $password_repate;
    public $customer_firstname;
    public $customer_lastname;
    public $customer_gender;



    public static function model($className='customer_entity')
    {
        return parent::model($className);
    }


    public function rules()
    {
        return array(

                array('customer_email, customer_pwd,password_repate,customer_firstname,customer_lastname,customer_gender', 'required'),
                array('customer_gender', 'numerical', 'integerOnly'=>true),
                array('customer_firstname, customer_lastname', 'length', 'max'=>32),
                array('customer_email', 'length', 'max'=>128),
                array('customer_email','email'),
                array('customer_email','unique','caseSensitive'=>false,'className'=>'customer_entity'),
                array('password_repate','compare','compareAttribute'=>'customer_pwd'),
                array('customer_pwd', 'length','min'=>8,'max'=>32),
            
        );

    }


    public function register()
    {
        $customer=new customer_entity();
        $customer->customer_email=$this->customer_email;
        $customer->customer_active=1;
        $customer->customer_default_group_ID=1;
        $customer->customer_first_name=$this->customer_firstname;
        $customer->customer_last_name=$this->customer_lastname;
        $customer->customer_gender=$this->customer_gender;
         $customer->customer_password=$this->customer_pwd;

        if($customer->save())
        {
           customer_group::addment($customer->customer_ID, null,1);
            return true;
        }
       return false;
    }
}

?>
