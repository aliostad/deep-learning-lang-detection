<?php
/**
 * Created by PhpStorm.
 * User: matthewtrask
 * Date: 11/1/15
 * Time: 9:16 PM
 */

use \helpers\url;

?>

<div class="row">
    <div class="small-12 columns">
        <h2>Current Show</h2>
        <p>Update and edit the current show being preformed at OBCT</p>
    </div><hr>
</div>

<div class="row">
    <div class="small-6 columns">
        <h4>Current Show</h4>
        <?php foreach($data['currentShow'] as $currentShow){
            echo "<h5><b>Title</b>: ".$currentShow->show_title."</h5>";
            echo "<h5><b>Description</b>: ".$currentShow->description."</h5>";
            echo "<h5><b>Dates</b>: ".$currentShow->dates."</h5>";
            echo "<h5><b>Price</b>: ".$currentShow->price."</h5>";
            echo "<h5><b>Link</b>: ".$currentShow->box_office_link."</h5>";
            echo "<h5><b>Image</b>:</h5> <img src=data:image/jpg;base64,$currentShow->image>";
        } ?>
    </div>
    <div class="small-6 columns">
        <h4>Update Current Show</h4>
        <form method="post" action="" enctype="multipart/form-data">
          <legend>Show Uploader</legend><br>
          <label>Show Title
            <input type="text" placeholder="Show Title" for="currentShow" name="showTitle">
          </label>
          <label>Show Description
            <textarea type="text" col="10" rows="6" placeholder="Show Description" for="showDescription" name="showDescription"></textarea>
          </label>
          <label>Show Dates
            <input type="text" placeholder="Show Dates" for="showDate" name="showDate">
          </label>
          <label>Show Price
            <input type="text" placeholder="Show Price" for="showPrice" name="showPrice">
          </label>
          <label>Show Tickets
            <input type="text" placeholder="Show Tickets" for="showTickets" name="showTickets">
          </label>
          <label>Show Image
            <input type="file" placeholder="Show Image" for="showTickets" name="showTickets">
          </label>
          <button id="submitShowInfo" name="submitShowInfo" for="submitShowInfo" >Submit</button>
          <div id="output"></div>
        </form>
    </div>
</div>
