<?php

/* * *********************
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  @author Sunnefa Lind <sunnefa_lind@hotmail.com>
 * ********************* */

/**
 * Represents a single show
 *
 * @author Sunnefa Lind <sunnefa_lind@hotmail.com>
 */
class Show extends Model {
    
    /**
     * The id of the show
     * @var int 
     */
    protected $show_id;
    
    /**
     * The title of the show
     * @var string 
     */
    protected $show_name;
    
    /**
     * The description of the show
     * @var string 
     */
    protected $show_description;
    
    /**
     * The thumbnail of the show
     * @var string 
     */
    protected $show_thumbnail;
    
    /**
     * Constructor
     * @param DBWrapper $db_wrapper
     * @param int $show_id 
     */
    public function __construct(DBWrapper $db_wrapper, $show_id = 0) {
        $this->db_wrapper = $db_wrapper;
        
        $this->table_name = 'episodey__shows';
        
        if($show_id) {
            $this->select_season($show_id);
        }
    }
    
    /**
     * Selects a single show and binds the data to this object
     * @param int $show_id
     * @return boolean 
     */
    private function select_season($show_id) {
        $show = $this->db_wrapper->select_data($this->table_name, '*', 'show_id = ' . $show_id);
        if($show) {
            $show = Functions::array_flat($show);
            
            $this->show_id = $show['show_id'];
            $this->show_name = $show['show_name'];
            $this->show_description = $show['show_description'];
            $this->show_thumbnail = $show['show_thumbnail'];
        } else {
            return false;
        }
    }
    
    /**
     * Get all shows
     * @return boolean 
     */
    public function get_all_shows() {
        $shows = $this->db_wrapper->select_data($this->table_name, '*');
        if($shows) return $shows;
        else return false;
    }
    
    /**
     * Add a show
     * @param array $show_data
     * @return boolean 
     */
    public function add_show($show_data) {
        $success = $this->db_wrapper->insert_data($this->table_name, array(
            'show_name' => $show_data['name'],
            'show_description' => $show_data['description'],
            'show_thumbnail' => $show_data['thumbnail'],
        ));
        if($success) return true;
        else return false;
    }
    
    /**
     * Delete a show
     * @param int $show_id
     * @return boolean 
     */
    public function delete_show($show_id) {
        $success = $this->db_wrapper->delete_data($this->table_name, 'show_id = ' . $show_id);
        if($success) return true;
        else return false;
    }
    
    /**
     * Updates a show
     * @param array $show_data
     * @return boolean 
     */
    public function update_show($show_data) {
        $success = $this->db_wrapper->update_data($this->table_name, array(
            'show_name' => $show_data['name'],
            'show_description' => $show_data['description'],
            'show_thumbnail' => $show_data['thumbnail'],
        ), 'show_id = ' . $show_data['id']);
        if($success) return true;
        else return false;
    }
}

?>
