<?php
class Cartlibrary {
 //check that each item has enough in stock from the database
	public static function check_inventory()
	{
		$contents	= Cart::content();

		//this array merges any products that share the same product id
		$new_contents	= array();
		foreach($contents as $c)
		{
			// skip gift card products
			if(isset($c['is_gc']))
			{
				continue;
			}

			//combine any product id's and tabulate their quantities
			if(array_key_exists($c['id'], $new_contents))
			{
				$new_contents[$c['id']]	= intval($new_contents[$c['id']])+intval($c['qty']);
			}
			else
			{
				$new_contents[$c['id']]	= $c['qty'];
			}
		}

		$error	= '';
		
		foreach($contents as $key=>$pnamecheck)
		{
		$product1	= Productsmodel::get_product($pnamecheck['id']);
		if(empty($product1))
		{
		$error .= '<p>'.sprintf('Product Not Found', $pnamecheck['name']).'</p>';
		}
		
		}
		
		foreach($new_contents as $product_id => $quantity)
		{
		
			$product	= Productsmodel::get_product($product_id);

			if(!empty($product)) {//make sure we're tracking stock for this product
			if($product->track_stock)
			{
				if(intval($quantity) > intval($product->quantity))
				{
					$error .= '<p>'.sprintf('Not Enough Stock', $product->name, $product->quantity).'</p>';
				}
			}
			}
			else
			{
			return $error;
			}
		}

		if(!empty($error))
		{
			return $error;
		}
		else
		{
			return false;
		}
	}
	
	public static function save_order(){
	 
	//prepare our data for being inserted into the database
		$save	= array();
		$none_shippable = true;
                $order = Cart::content();
		if(isset($item['options']['shippable']))
		{
			if($item['options']['shippable']==1)
			{
			
				$none_shippable = false;
			}
			}
		//default status comes from the config file
		if($none_shippable)
		{
			$save['status']				= 'Pending';
		} else {
			$save['status']				= 'Pending';
		}

		//if the id exists, then add it to the array $save array and remove it from the customer
		if(isset($item['options']['apiproduct']['Customer_Id'][0]->id) && $item['options']['apiproduct']['Customer_Id'][0]->id != '')
		{
			$save['customer_id']	= $item['options']['apiproduct']['Customer_Id'][0]->id;
		}
		
                $cus=$item['options']['apiproduct']['Customer_Id'];
                foreach($item['options']['apiproduct']['Customer_Id'] as $customer)
                {
                $save['company']		= $customer->company;
		$save['firstname']		= $customer->firstname;
		$save['lastname']		= $customer->lastname;
		$save['phone']			= $customer->phone;
		$save['email']			= $customer->email;
		
		if(isset($customer->default_shipping_address))
		{
		$ship				= $customer['default_shipping_address'];

		$save['ship_company']		= $customer->company;
		$save['ship_firstname']		= $customer->firstname;
		$save['ship_lastname']		= $customer->lastname;
		$save['ship_email']		= $customer->email;
		$save['ship_phone']		= $customer->phone;
		$save['ship_address1']		= $customer->address1;
		//$save['ship_address2']		= $ship['address2'];
		$save['ship_city']		= $customer->city;
		$save['ship_zip']		= $customer->pincode;
		//$save['ship_zone']		= $customer['pincode'];
		$save['ship_zone_id']		= $customer->zone_id;
		$save['ship_country']		= $customer->country;
		$save['ship_country_id']	= $customer->country_id;
                }
                if(isset($customer->default_billing_address)){ 
                $bill				= $customer['default_billing_address'];
		
                }}
		
		$save['shipping_method']	         = '';
		$save['shipping']			 = '';
	        $save['tax']				='';
	        $save['gift_card_discount']             = '';
		$save['ordered_on']= date('Y-m-d H:i:s');
                $item=Cart::content();
		$contents= array();

		foreach(Cart::content() as $key=>$item)
		{
		
		
			$contents[$key]				= serialize($item);
			
		}
                // save the order content
		$order_id = Ordermodel::save_order($save, $contents);
               
            
		return $order_id;
	
	
	
	}
	public static function save_physical_order(){
	        $save	= array();
                $none_shippable = false;
	        $order = Cart::content();
		$shippable=1;
		if(isset($item['options']['shippable']))
		{
			if($item['options']['shippable']==1)
			{
			
				$none_shippable = false;
			}
			}
	        //default status comes from the config file
		if($shippable)
		{
			$save['status']				= 'Pending';
		} else {
			$save['status']				= 'Pending';
		}
                 $customer = Session::get('customer');
                 $customer_data = Session::get('customer_data');
                 $save['customer_id']            =  $customer_data->id;
                if(isset($customer['ship_address']))
		{
	        $save['ship_firstname']		= $customer['ship_address']['firstname'];
		$save['ship_email']		= $customer['ship_address']['email'];
		$save['ship_phone']		= $customer['ship_address']['phone'];
		$save['ship_address1']		= $customer['ship_address']['address1'];
		 }
                $save['shipping_method']	         = '';
		$save['shipping']			 = '';
	        $save['tax']				='';
	        $save['gift_card_discount']             = '';
		$save['ordered_on']= date('Y-m-d H:i:s');
		$item=Cart::content();
		$contents= array();
                foreach(Cart::content() as $key=>$item)
		{
		$contents[$key]				= serialize($item);
		}
               $order_id = Ordermodel::save_physical_order($save, $contents);
                return $order_id;
	
	
	
	}

	function partner_discount($point,$partner_id){
	
	
	}
	
	public static function save_digital_order($id=false,$param=false,$pg_status=false,$pg_ref=false){

	        $save	= array();
                $none_shippable = false;
	        $order = Cart::content();
		
		
	        //default status comes from the config file
		     
			$customer_data = Session::get('customer_data');
			$save['customer_id']            =  $customer_data->id;
			$save['status']='Pending';
                       
               		$save['ordered_on']= date('Y-m-d H:i:s');
			if($param);
			{
			  $save['id']=$id;
			}
		$item=Cart::content();
              
		$contents= array();
                foreach(Cart::content() as $key=>$item)
		{
                   $save['email']=$item['options']['apiproduct']['Posted']['s_email'];
               
		$contents[$key]	= serialize($item);
                
		}
		
                $order_id = Ordermodel::save_order($save, $contents,$pg_status,$pg_ref);

                return $order_id;
	
	
	
	}
	
	
  
  }
