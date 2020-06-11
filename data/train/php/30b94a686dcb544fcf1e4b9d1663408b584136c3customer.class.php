<?

class Customer {
  var $CustomerArr;

  function Customer($CustomerArr)
  {
    $this->CustomerArr=$CustomerArr;
    register_shutdown_function(array(&$this, '_Customer'));
  } 
  
  function _Customer()
  {
    $_SESSION[customerlist]=$this->CustomerArr;    
    //print_r($_SESSION[articlelist]);
  }

  function CustomerDelete()
  {
    unset($this->CustomerArr);
  }

  function CustomerSave($ArrData) 
  {
    foreach ($ArrData as $key=>$value) 
    {
      $this->CustomerArr[$key]=$value;
    }
  }
  


}
?>
