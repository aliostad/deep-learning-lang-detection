<?php namespace App\Http\ViewComposers;

use App\Raid;
use Illuminate\Contracts\View\View;


class DefaultRaidComposer {

    public function compose(View $view){
        /*if(\Cache::has('default_raid')){
            $view->with('default_raid', \Cache::get('default_raid'));
            $view->with('show_sign_history', \Cache::get('show_sign_history'));
            $view->with('show_contact', \Cache::get('show_contact'));
            $view->with('show_patrons', \Cache::get('show_patrons'));
            $view->with('page_title', \Cache::get('default_page_title'));
            return;
        }*/
        $raid = Raid::where('active_raid', '=', true);
        /*
        $view->with('default_raid', $raid);
        \Cache::forever('default_raid', $raid);
        $view->with('show_sign_history', $raid->show_sign_history);
        \Cache::forever('show_sign_history', $raid->show_sign_history);
        $view->with('show_contact', $raid->show_contact);
        \Cache::forever('show_contact', $raid->show_contact);
        $view->with('show_patrons', $raid->show_patrons);
        \Cache::forever('show_patrons', $raid->show_patrons);
        $view->with('default_page_title', $raid->number.' Rajd Rodło');
        \Cache::forever('default_page_title',  $raid->number.' Rajd Rodło');
        */
    }

}