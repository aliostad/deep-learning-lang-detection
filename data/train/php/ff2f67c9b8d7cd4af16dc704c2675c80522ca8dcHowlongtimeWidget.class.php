<?php
class HowlongtimeWidget extends Widget{
    public function render($data){
        if(!empty($data['mktime'])){
            $show_cemktime = $data['mktime']; 
            if(mktime()>=$show_cemktime){
                $show_cetime = mktime()-$show_cemktime;          
                if($show_cetime<432000){ 
                    if($show_cetime<60){ 
                        $returncontent = '刚刚'; 
                    }elseif($show_cetime<3600){  
                        $returncontent = ((int)($show_cetime/60)).'分钟前';
                    }elseif($show_cetime<86400){ 
                        $returncontent = ((int)($show_cetime/3600)).'小时前'; 
                    }else{ 
                        $returncontent = ((int)($show_cetime/86400)).'天前'; 
                    }
                }else{ 
                    $returncontent = Date("Y-m-d H:i",$show_cemktime); 
                }
            }else{
                $returncontent = '不久的将来';
            }
            $content = $returncontent;
        }else{
            $content = false;
        }
        return $content;
    }
}

?>
