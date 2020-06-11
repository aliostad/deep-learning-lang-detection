<?
class Shows extends BaseModel {
    var $_name = "shows";
    
    public function selectAll() {
        $all_shows = array();
        
        $result = $this->DB()->query("SELECT id FROM `shows` WHERE `active`='1' ORDER BY NAME");
        while($show = $result->fetch_object()) {
            $all_shows[] = $show->id;
        }
        
        return $all_shows;
    }
    
    public function setShow($show_id) {
        $this->active_show = $show_id;
        $this->_show       = new Show($show_id);
        return $this->_show;
    }
    
    public function getShow() {
        return $this->_show;
    }
}
?>