<?php
defined('MOODLE_INTERNAL') or die("Direct access to this location is not allowed.");
require_once("$CFG->dirroot/blocks/course_copy/lib.php");

$settings->add(new admin_setting_heading('block_course_copy_plugin',
  course_copy::str('coursecopysettings'),
  course_copy::str('coursecopydescription')
));

$settings->add(new admin_setting_configcheckbox('block_course_copy_transfer_grades',
  course_copy::str('transfergrades'),
  course_copy::str('transfergradesdescription'), '0', '1', '0'
));

$settings->add(new admin_setting_configcheckbox('block_course_copy_replace',
  course_copy::str('replace'),
  course_copy::str('replacedescription'), '0', '1', '0'
));

$settings->add(new admin_setting_configtext('block_course_copy_cron_timeout',
    course_copy::str('crontimeout'),
    course_copy::str('crontimeoutdescription'), 5, PARAM_INT
));
