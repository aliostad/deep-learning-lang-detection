<?php
/*****************************************************************************************************************
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2016/9/1
 * Time: 16:33
 *****************************************************************************************************************/

namespace App\Services;

use App\Dao\CustomerDao;

use App\Http\SDP_DEFINE;

use App\Http\Utils;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class CustomerService
{

    function __construct()
    {

    }

    public function queryCustomer($arrData)
    {

        $CustomerDao = new CustomerDao();
        return $CustomerDao->queryCustomer($arrData);
    }

    /**根据ID获取帐号信息
     * @param 帐号 $id
     * @return array
     */
    public function getCustomerById($id)
    {
        $CustomerDao = new CustomerDao();
        return $CustomerDao->getCustomerById($id);
    }

    /**
     * @param $arrData
     * @return bool
     */
    public function updateCustomer($arrData)
    {
        $CustomerDao = new CustomerDao();
        return $CustomerDao->updateCustomer($arrData);
    }

    /**新增
     * @param
     * @return array
     */
    public function insertCustomer($arrData)
    {
        $CustomerDao = new CustomerDao();
        return $CustomerDao->insertCustomer($arrData);
    }


    /**删除帐号
     * @param
     * @return array
     */
    public function deleteCustomerById($customer_id)
    {
        $CustomerDao = new CustomerDao();
        $CustomerDao->deleteCustomerById($customer_id);
        //删除与账号有关的表数据

        return true;
    }

    /**更新密码
     * @param
     * @return array
     */
    public function updateCustomerPwd($arrData,$id){
        $CustomerDao = new CustomerDao();
        $CustomerDao->updateCustomerPwd($arrData,$id);

        return true;
    }



    /**
     * 校验密码当前密码是否正确
     * @param $customer_id
     * @param $password
     * @return bool
     */
    public function passwordVerify($customer_id, $customer_password)
    {
        $CustomerDao = new CustomerDao();
        $item = $CustomerDao->getCustomerById($customer_id);
        if(!$item) return false;
        return password_verify($customer_password, $item->password);
    }

    /**更新用户头像
     * @param
     * @return array
     */
    public function updateCustomerPhoto($arrData,$id){
        $CustomerDao = new CustomerDao();
        $CustomerDao->updateCustomerPic($arrData,$id);

        return true;
    }

}