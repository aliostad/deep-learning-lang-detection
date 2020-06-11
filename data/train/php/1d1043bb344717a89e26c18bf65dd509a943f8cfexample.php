<?php

   // sınıfı dahil edelim
   require "db.show.class.php";
   
   // sınıfı başlatalım
   $db_show = new db_show("host","user","pass","db");
   
   // tabloları dizi halinde görelim
   $db_show->_dump( $db_show->show_tables() );
   
   // tabloya ait alanları dizi halinde görelim
   $db_show->_dump( $db_show->show_fields("tablo_adi") );
   
   // tablo ve alanları bir arada html olarak görelim
   echo $db_show->show_tables_and_fields();
   
   // sadece tabloları html olarak görelim
   echo $db_show->show_tables(true);
   
   // sadece tabloya ait alanları html olarak görelim
   echo $db_show->show_fields("tablo_adi", true);
   
?>
