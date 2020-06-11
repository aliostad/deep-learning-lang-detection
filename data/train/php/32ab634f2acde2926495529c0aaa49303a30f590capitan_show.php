<?php

class CapitanShow {

  public $presenter_name, $capi_show_detail_url, $show_detail_url, $title, $venue,
                    $date, $show_type, $calendar_text, $buy_tickets_url;

  function __construct($json_show) {
    $this->presenter_name = $json_show->presenter_name;
    $this->capi_show_detail_url = $json_show->capi_show_detail_url;
    $this->show_detail_url = $json_show->show_detail_url;
    $this->title = $json_show->title;
    $this->venue = $json_show->venue;
    $this->date = $json_show->date;
    $this->show_type = $json_show->show_type;
    $this->calendar_text = $json_show->calendar_text;
    $this->buy_tickets_url = $json_show->buy_tickets_url;
  }

}

?>