<?php 

require_once 'facade.php';
/**
* Search Model
*/

class SearchModel
{
  
  public function SearchCards($search_string)
  {
    $facade = new Facade();  
    $result_search = $facade->SearchCards($search_string);
    $count = 0;
    foreach ($result_search as $one) {
      $card_id = $one["id"];
      
      $result_search[$count]["education_model"] = $facade->GetSubTable("education", $card_id);
      $result_search[$count]["post_education_model"] = $facade->GetSubTable("post_education", $card_id);
      $result_search[$count]["family_model"] = $facade->GetSubTable("family", $card_id);
      $count++;
    }

    

    return json_encode($result_search);
  }
}
?>