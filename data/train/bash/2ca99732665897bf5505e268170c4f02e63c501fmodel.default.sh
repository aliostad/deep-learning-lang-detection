
# src/templates/model.default.sh

TMPLNAME+=('model.default')
TMPLDESC['model.default']="Basic PHP DAO Class."
TMPLFUNC['model.default']=templates_model_default

function templates_model_default {
  
  local dst=$1

  printf -- "    Creating ${dst}.\n"
    
  cat > ${dst}<<MODEL
  <?php  

  class ${TMPLDATA['model_name']}DAO  {  

      public \$prop1 = "I'm a class property!";  

      public function __construct()  
      {  
          echo 'The class "', __CLASS__, '" was initiated!<br />';  
      }  
  }  

  ?>  
MODEL
}
