<?php   if(!defined('DRPATH')) exit('·ÃÎÊ´íÎó');

/**
 * ÎÄ¼þ´¦Àísession»úÖÆ
 * 2014-12-10
 */
class drivers_session_filesHandler{
    private $save_path;
    
    public function open($savePath,$sessionName){
        if(!is_dir($savePath)){
            mkdir($savePath,0777);
        }
        $this->save_path = $savePath;
    }
    
    public function close(){
        
    }
    
    public function read($id){
        return @file_get_contents("$this->save_path/sess_$id");
    }
    
    public function write($id,$data){
        return @file_put_contents("$this->save_path/sess_$id",$data);
    }
    
    public function destroy($id){
        unlink("$this->save_path/sess_$id");
    }
    
    public function gc($maxlifetime){
        foreach ( glob ( " $this -> savePath /sess_*" ) as  $file ) {
            if ( filemtime ( $file ) +  $maxlifetime  <  time () &&  file_exists ( $file )) {
                unlink ( $file );
            }
        }
    }
}
?>