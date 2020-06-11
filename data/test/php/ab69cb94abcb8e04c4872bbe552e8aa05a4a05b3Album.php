<?php
   class Album extends AppModel
   {
       var $name = 'Album';

       function getNewAlbum($limit=5,$dk)
       {
       	  $listData = $this->find('all', array('order' => array('time'=> 'DESC'),
                                              'limit' =>$limit,
                                              'conditions' => $dk

                                            ));
          return $listData;
       }


       function saveAlbumNew($time,$title,$image,$key,$slug,$lock,$id= null)
       {
       	 $listSlug= array();
       	 $number= 0;
       	 $slugStart= $slug;
       	 do
       	 {
       	 	 $number++;
	       	 $listSlug= $this->find('all', array('conditions' => array('slug'=>$slug) ));
			 if(count($listSlug)>0 && $listSlug[0]['Album']['id']!=$id)
			 {
			 	$slug= $slugStart.'-'.$number;
	       	 }
       	 } while (count($listSlug)>0 && $listSlug[0]['Album']['id']!=$id);
       	 
       	 
         if($id != null)
         {
            $id= new MongoId($id);
            $save= $this->getAlbum($id);
         }
         else
         {
            $save['Album']['view']= 0;
            $save['Album']['_id']= new MongoId();
         }
         $save['Album']['title']= $title;
         $save['Album']['key']= $key;
         $save['Album']['img'][0]['src']= $image;
         $save['Album']['img'][0]['alt']= $title;
         $save['Album']['time']= $time;
         $save['Album']['slug']= $slug;
         $save['Album']['lock']= $lock;

         $this->save($save);
         
         if($id != null) return $save['Album']['id'];
         else return $save['Album']['_id']->{'$id'};
       }
       
       function saveImgAlbum($image,$note,$id,$link,$idIMG)
       {
         $save= $this->getAlbum($id);
         if($save)
         {
         	if($idIMG!='')
         	{
	         	$n= (int) $idIMG;
         	}
         	else
         	{
            	$n= count($save['Album']['img']);
            }
            $save['Album']['img'][$n]['src']= $image;
            $save['Album']['img'][$n]['alt']= $note;
            $save['Album']['img'][$n]['link']= $link;
            $this->save($save, false, array('img'));
            return 1;
         }
         return 0;
       }
       
       function deleteImgAlbum($idXoa,$id)
       {
         $save= $this->getAlbum($id);
         if($save)
         {
            $dem= -1;
            $stt= -1;
            foreach($save['Album']['img'] as $img)
            {
              $dem++;
              if($dem != $idXoa)
              {
                $stt++;
                $tg[$stt]= $img;
              }
            }

            $save['Album']['img']= $tg;
            $this->save($save, false, array('img'));
            return 1;
         }
         return 0;
       }
       
       function getAlbum($id)
       {
         $dk = array ('_id' => $id);
         $return = $this -> find('first', array('conditions' => $dk) );
         return $return;
       }
       
       function getSlugAlbum($slug)
       {
         $dk = array ('slug' => $slug);
         $return = $this -> find('first', array('conditions' => $dk) );
         return $return;
       }
       
   }
?>