<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use DB;
use Auth;
use Request;
use Redirect;
use App\Helpers\Common;
class Service extends Model
{
   

    protected $primaryKey = 'service_id';
    
    public $timestamps = false;
    
    protected $table = 'service';
    
    protected $fillable = ['service_name', 'status','date_added'];
    
    public function getAllServices($serviceId=NULL) {
        if(!empty($serviceId)){
          $services = Service::select('service_id','service_name','status','date_added')->where('service_id',$serviceId)->get();  
        }else{
          $services = Service::select('service_id','service_name','status','date_added')->orderBy('service_name','asc')->get();  
        }
        $getData=$services->toArray();
        if(!empty($getData)){
            return $getData;
        }else{
            return NULL;
        }
        
    }
    
    public function editServiceDetails($serviceData){
        $newServiceName=$serviceData['serviceName'];
        $checkServiceExist=Service::where('service_name',$newServiceName)->get();
        $checkService=$checkServiceExist->toArray();
        //echo "<pre>";print_r(serviceData);die;
         if(is_array($checkService) && sizeof($checkService)>0 && $serviceData['serviceId']!=$checkService[0]['service_id']){
                return 'service_name_exist';die; 
         }else{
            if(empty($serviceData['serviceName']) || empty($serviceData['status'])){
                return 'input_required';die;
            }
            $txn=DB::transaction(function ($serviceData) use ($serviceData){
                    try{
                        if(!empty($serviceData['serviceId'])){
                            $updateserviceData=Service::where('service_id',$serviceData['serviceId'])
                                            ->update(['service_name'=>$serviceData['serviceName'],'status'=>$serviceData['status']]);
                        }else{

                        }

                    }catch(ValidationException $e){

                    }
            });
            return 'success';die;
        }
    }

    public function addNewService($serviceData){
        $newServiceName=$serviceData['serviceName'];
        $checkServiceExist=Service::where('service_name',$newServiceName)->get();
        $checkService=$checkServiceExist->toArray();

        if(is_array($checkService) && sizeof($checkService)>0){
            return 'service_name_exist';die; 
        }else{
            if(empty($serviceData['serviceName']) || empty($serviceData['status'])){
                return 'input_required';die;
            }
            $txn=DB::transaction(function ($serviceData) use ($serviceData){
                try{
                      if(!empty($serviceData['serviceName']) && !empty($serviceData['status'])){
                        $addData=Service::insertGetId(['service_name'=>$serviceData['serviceName'],'status'=>$serviceData['status'],
                                    'date_added'=>Common::InsertDBDateNow()]); 
                       }
                       
                 }catch(ValidationException $e){

                }
            });
                return 'success';die;
         }
    }

    public function deleteServiceDetails($serviceData){
        $delete = Service::where('service_id', $serviceData['serviceId'])->delete();
        if($delete){return 'success';}else{return 'failed';}
    }
}
