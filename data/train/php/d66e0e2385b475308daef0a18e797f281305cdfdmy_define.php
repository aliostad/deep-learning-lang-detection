<?php
class  FileSessionHandler
{
    private  $savePath ;
    public function __construct($savePath){
        $this->savePath = $savePath;
    }

    function  open ( $savePath ,  $sessionName )
    {
         $this -> savePath  =  $savePath ;
        if (! is_dir ( $this -> savePath )) {
             mkdir ( $this -> savePath ,  0777 );
        }

        return  true ;
    }

    function  close ()
    {
        return  true ;
    }

    function  read ( $id )
    {
        return (string)@ file_get_contents ( " $this -> savePath /trong_ $id " );
    }

    function  write ( $id ,  $data )
    {
        echo "id=$id****<br/>".$this->savePath;
        return  file_put_contents ( " $this -> savePath /trong_ $id " ,  $data ) ===  false  ?  false  :  true ;
    }

    function  destroy ( $id )
    {
         $file  =  " $this -> savePath /trong_ $id " ;
        if ( file_exists ( $file )) {
             unlink ( $file );
        }

        return  true ;
    }

    function  gc ( $maxlifetime )
    {
        foreach ( glob ( " $this -> savePath /trong_*" ) as  $file ) {
            if ( filemtime ( $file ) +  $maxlifetime  <  time () &&  file_exists ( $file )) {
                 unlink ( $file );
            }
        }

        return  true ;
    }
    public function getSavePath(){
        return $this->savePath;
    }
  
    public function setSavePath($savePath)
    {
        $this->savePath = $savePath;
    }
}

    $handler  = new  FileSessionHandler ("C:/mysession");
    echo "savePath = ".$handler->getSavePath()."<br/>";
    session_set_save_handler (
    array( $handler ,  'open' ),
    array( $handler ,  'close' ),
    array( $handler ,  'read' ),
    array( $handler ,  'write' ),
    array( $handler ,  'destroy' ),
    array( $handler ,  'gc' )
    );

    // 下面这行代码可以防止使用对象作为会话保存管理器时可能引发的非预期行为
    register_shutdown_function ( 'session_write_close' );
    
    session_start ();
    // 现在可以使用 $_SESSION 保存以及获取数据了 
    
    //保存一个session
    $_SESSION['aa'] = "helloworld";
    echo "写入成功";
?>