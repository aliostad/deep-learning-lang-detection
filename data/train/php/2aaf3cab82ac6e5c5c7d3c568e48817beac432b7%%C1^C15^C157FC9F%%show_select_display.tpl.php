<?php /* Smarty version 2.6.26, created on 2010-12-12 03:49:50
         compiled from show_select_display.tpl */ ?>
<form method="post" action="show_select_display_week.php" target="_blank" id="show_select_display">
  <input type="hidden" name="username" id="show_username">
    <input type="hidden" name="user" id="show_user">
    <input type="hidden" name="device" id="show_device">
    <input type="hidden" name="devicename" id="show_devicename">
      
    <input type="hidden" name="year" id="show_year">
    <input type="hidden" name="month" id="show_month">
    <input type="hidden" name="day" id="show_day">
</form>
<script>
<?php echo '
function show_display_week() {
  //jQuery("#selectpeople option").attr("selected", "selected");
  //jQuery("#selectdevice option").attr("selected", "selected");
  jQuery("#selectdevice option").each(function(){
    show_device = $(\'#show_device\').val();
    show_devicename = $(\'#show_devicename\').val();
    if(show_device) {
      show_device += \',\'+ $(this).val();
      show_devicename += \',\'+$(this).text();
      $(\'#show_device\').val(show_device);
      $(\'#show_devicename\').val(show_devicename);
    } else {
      show_device = $(this).val();
      show_devicename = $(this).text();
      $(\'#show_device\').val(show_device);
      $(\'#show_devicename\').val(show_devicename);
    }
  });
  
  jQuery("#selectpeople option").each(function(){
    
    show_username = $(\'#show_username\').val();
    show_user = $(\'#show_user\').val();
    if(show_user) {
      show_user += \',\'+ $(this).val();
      show_username += \',\'+$(this).text();
      $(\'#show_user\').val(show_user);
      $(\'#show_username\').val(show_username);
    } else {
      show_user = $(this).val();
      show_username = $(this).text();
      $(\'#show_user\').val(show_user);
      $(\'#show_username\').val(show_username);
    }
  });
  
  $(\'#show_year\').val($(\'#startYear option:selected\').val());
  $(\'#show_month\').val($(\'#startMonth option:selected\').val());
  $(\'#show_day\').val($(\'#startDay option:selected\').val());
  
  $(\'#show_select_display\').submit();
}
'; ?>

</script>