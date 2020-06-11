<?php

namespace Users\Home;

function restoreVisibilities ($mysqli, $id_users) {
    $sql = 'update users set show_admin = 1,'
        .' show_bar_charts = 1, show_new_bar_chart = 0,'
        .' show_bookmarks = 1, show_new_bookmark = 0,'
        .' show_calculations = 1, show_new_calculation = 0,'
        .' show_calendar = 1, show_new_event = 0, show_contacts = 1,'
        .' show_new_contact = 0, show_files = 1, show_upload_files = 0,'
        .' show_notes = 1, show_new_note = 0, show_notifications = 1,'
        .' show_post_notification = 0, show_places = 1,'
        .' show_new_place = 0, show_schedules = 1, show_new_schedule = 0,'
        .' show_tasks = 1, show_new_task = 0, show_wallets = 1,'
        .' show_new_wallet = 0, show_new_transaction = 0,'
        .' show_new_transaction = 0, show_transfer_amount = 0,'
        ." show_trash = 1 where id_users = $id_users";
    include_once __DIR__.'/../../mysqli_query_exit.php';
    mysqli_query_exit($mysqli, $sql);
}
