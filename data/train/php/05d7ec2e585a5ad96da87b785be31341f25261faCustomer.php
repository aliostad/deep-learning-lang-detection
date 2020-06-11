<?php

class Customer extends \Eloquent {
	protected $fillable = [];

	public static function UpdateInfo($username,$data)
	{
		$customer = Customer::where('username',$username)->first();

		if( $customer->mobile != $data['mobile'] )
		{
			//如果要修改手机号，那么手机号的验证状态就要归零，重新验证
			$customer->mobile_status = 0;
		}
		$customer->mobile = $data['mobile'];

		$customer->birthday = $data['birthday'];

		if( $data['sex'] == 1 )
		{
			$customer->sex = '男';
		}
		else
		{
			$customer->sex = '女';
		}

		if( $customer->email != $data['email'] )
		{
			$customer->email_status = 0;
		}
		$customer->email = $data['email'];

		$customer->save();
		return 1;
	}

}