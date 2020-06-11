<?php
namespace Home\Model;
use Think\Model;
class TranslationImageModel extends Model{
    //
    public function saveImage($_params){
        return $this->save($_params);
    }

    public function addImage($_params){
        return $this->add($_params);
    }

    public function del($_where){
        $save['status'] = '0';
        return $this->where($_where)->save($save);
    }

    public function clear($_where){
        $save['status'] = '0';
        return $this->where($_where)->save($save);
    }

    public function gets($_where){
        return $this->where($_where)->select();
    }

    // public function getOneImage($_iid){
    //     return $this->where(array('id'=>intval($_iid)))->find();
    // }
}
?>