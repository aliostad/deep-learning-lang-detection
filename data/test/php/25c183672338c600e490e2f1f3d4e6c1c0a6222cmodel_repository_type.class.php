<?php

class model_repository_type extends Model {
    public function getTableName(){
        return 'repository_type';
    }

    function getArrayData(){
        $sql = sprintf('select * from repository_type order by id');
        $repository_type_res = mysql_query($sql, $this->getDb());

        $data = array();
        while($repository_type_ary = mysql_fetch_array($repository_type_res)){
            $data[$repository_type_ary['id']] = $repository_type_ary['name'];
        }

        return $data;
    }
}
