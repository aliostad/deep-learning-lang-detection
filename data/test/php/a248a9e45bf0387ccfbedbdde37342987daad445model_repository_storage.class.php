<?php

class model_repository_storage extends Model {
    public function getTableName(){
        return 'repository_storage';
    }

    function getArrayData(){
        $sql = sprintf('select * from repository_storage order by id');
        $repository_storage_res = mysql_query($sql, $this->getDb());

        $data = array();
        while($repository_storage_ary = mysql_fetch_array($repository_storage_res)){
            $data[$repository_storage_ary['id']] = $repository_storage_ary['name'];
        }

        return $data;
    }
}
