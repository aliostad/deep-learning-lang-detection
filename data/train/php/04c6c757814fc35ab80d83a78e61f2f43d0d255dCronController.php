<?php

class CronController extends Controller {

    /**
     * Display a listing of the resource.
     * GET /cron
     *
     * @return Response
     */
    public function index()
    {
        $hash      = Route::input('hash');
        $noOfShows = Route::input('noOfShows');
        $time      = Route::input('hours');

        if ($hash === "42ed511a21ecf174b162ea02afa6a523")
        {
//            $time = \Carbon\Carbon::now(new DateTimeZone(date_default_timezone_get()))->subMinutes(60)->toDayDateTimeString();

            $api = new API;
            $content = $api->getUpdates($time);

            $i = 1;
            foreach ($content['show'] as $row)
            {
                if($row['last'] > 0 )
                {
                    if ($noOfShows != null && $i == $noOfShows)
                    {

                        if ($show = Show::where('show_id', $row['id'])->first())
                        {
                            $show = $this->updateShowData($show, $row['id']);

                            if($row['lastepisode'] > 0 )
                            {
                                $this->updateEpisodesData($show, $row['id']);
                            }
                        }
                        $this->saveShow($row['id']);

                        if ($i ++ == 3) sleep(2);
                    }
                }
            }
        }
    }


    public function checkShow($sid)
    {
        if ($show = Show::where('show_id', $sid)->first())
        {
            return $this->updateShowData($show, $sid);
        }
        return $this->saveShow($sid);
    }



    public function saveShow($sid)
    {
        // echo  " ::---> Show save Id ::--> " . $sid;
        // echo "<br>";

        $api = new API;
        return $api->getShow($sid);
    }



    public function updateShowData($show, $sid)
    {

        // echo  " ::---> Show update Id ::--> " . $sid;
        // echo "<br>";
        $api = new API;

        $api_url = "full_show_info.php?sid=" . $sid;

        $content = $api->get_content($api_url);

        $data = $api->convert_to_array($content);



        // $show         = [];
        // // $showDetails  = Show::with('genre')->find($shows->id);
        // // $totalseasons = Show::find($shows->id)->sessions()->count();

        // $show['name']           = Input::get('name');
        // $show['link']           = Input::get('link');
        // $show['start_date']     = Input::get('start_date');
        // $show['end_date']       = Input::get('end_date');
        // // $show['image']          = Input::get('image');
        // $show['origin']         = Input::get('origin');
        // $show['status']         = Input::get('status');
        // $show['runtime']        = Input::get('runtime');
        // $show['network']        = Input::get('network');
        // $show['airtime']        = Input::get('airtime');
        // $show['airday']         = Input::get('airday');
        // $show['summary']        = Input::get('summary');
        // $show['class']          = Input::get('classification');


        // Show::whereId($sid)->update($show);

         return $api->updateShow($show, $sid, $data);

         // return View::make("hello");

    }


    public function updateEpisodesData($show, $sid)
    {
        // echo  " ::---> Episode update Id ::--> " . $sid;
        // echo "<br>";
        $api = new API;

        $api_url = "full_show_info.php?sid=" . $sid;

        $content = $api->get_content($api_url);

        $data = $api->convert_to_array($content);

        $sessions = $api->storeSessions($data['totalseasons'], $show->id);

        $api->storeEpisodes($data, $sessions, $show->id);

        // return View::make("hello");

    }

    public function adminShowUpdate($sid)
    {
        $show = Show::whereId($sid)->first();
        $this->updateShowData($show, $show->show_id);
        $this->updateEpisodesData($show, $show->show_id);
        return Redirect::back()->with('message', 'Your show has been updated!');
    }
}






