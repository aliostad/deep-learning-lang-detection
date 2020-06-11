<?php
    
    require_once('../inc/class.Showing.inc');

    class ShowingCollector {
        public function getNowShowingList(){
            $showingList = array();

            // show 1
            $show = new Showing;
            $show->id               = 1;
            $show->name             = 'American Hustle';
            $show->imageURL         = '';
            $show->imageThumbURL    = 'http://appdul/img/movie2_thumb.png';
            $show->trailerURL       = '';
            $show->imdbScore        = 0;
            $show->duration         = '';
            $show->type             = 'Crime,Drama';
            $show->peopleWatched    = 0;
            array_push( $showingList, $show);
            // show 2
            $show = new Showing;
            $show->id               = 2;
            $show->name             = '47 Ronin';
            $show->imageURL         = '';
            $show->imageThumbURL    = 'http://appdul/img/movie3_thumb.png';
            $show->trailerURL       = '';
            $show->imdbScore        = 0;
            $show->duration         = '';
            $show->type             = 'Action,Adventure';
            $show->peopleWatched    = 0;
            array_push( $showingList, $show);
            // show 3
            $show = new Showing;
            $show->id               = 3;
            $show->name             = 'Frozen';
            $show->imageURL         = '';
            $show->imageThumbURL    = 'http://appdul/img/movie4_thumb.png';
            $show->trailerURL       = '';
            $show->imdbScore        = 0;
            $show->duration         = '';
            $show->type             = 'Adventure, Animation';
            $show->peopleWatched    = 0;
            array_push( $showingList, $show);
            // show 4
            $show = new Showing;
            $show->id               = 4;
            $show->name             = 'Captain Philips';
            $show->imageURL         = '';
            $show->imageThumbURL    = 'http://appdul/img/movie1_thumb.png';
            $show->trailerURL       = '';
            $show->imdbScore        = 0;
            $show->duration         = '';
            $show->type             = 'Action, Biography, Drama';
            $show->peopleWatched    = 0;
            array_push( $showingList, $show);
            // show 5
            $show = new Showing;
            $show->id               = 5;
            $show->name             = 'เลือกขัตติยา';
            $show->imageURL         = '';
            $show->imageThumbURL    = 'http://appdul/img/movie5_thumb.png';
            $show->trailerURL       = '';
            $show->imdbScore        = 0;
            $show->duration         = '';
            $show->type             = 'ละตรเวที';
            $show->peopleWatched    = 0;
            array_push( $showingList, $show);
            // show 6
            $show = new Showing;
            $show->id               = 6;
            $show->name             = 'Mary is Happy';
            $show->imageURL         = '';
            $show->imageThumbURL    = 'http://appdul/img/movie6_thumb.png';
            $show->trailerURL       = '';
            $show->imdbScore        = 0;
            $show->duration         = '';
            $show->type             = 'Drama';
            $show->peopleWatched    = 0;
            array_push( $showingList, $show);

            $json_return = json_encode( $showingList );

            return $json_return;
        }
    }

?>