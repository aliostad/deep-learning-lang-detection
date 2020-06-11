<?php
include_once(dirname(__FILE__).'/../../bootstrap/unit.php');
require_once(dirname(__FILE__).'/../../../lib/validator/cqCopyFieldsToEmbeddedFormValidatorSchema.class.php');

$t = new lime_test(2, array('output' => new lime_output_color(), 'error_reporting' => true));
$t->diag('Testing /lib/validator/cqCopyFieldsToEmbeddedFormValidatorSchema.class.php');


$values = array(
    'no_copy_field'   => 'no_copy_field',
    'copy_field'      => 'copy_field',
    'embedded_form_1' => array(
        'embedded_field_1' => 'embedded_field_1',
    ),
    'embedded_form_2' => array(
        'embedded_field_2' => 'embedded_field_2',
    ),
);

$expected_result = array(
    'no_copy_field'   => 'no_copy_field',
    'copy_field'      => 'copy_field',
    'embedded_form_1' => array(
        'embedded_field_1' => 'embedded_field_1',
        'copy_field'      => 'copy_field',
    ),
    'embedded_form_2' => array(
        'embedded_field_2' => 'embedded_field_2',
        'copy_field'      => 'copy_field',
    ),
);

$expected_result_with_remove_on_copy = array(
    'no_copy_field'   => 'no_copy_field',
    'embedded_form_1' => array(
        'embedded_field_1' => 'embedded_field_1',
        'copy_field'      => 'copy_field',
    ),
    'embedded_form_2' => array(
        'embedded_field_2' => 'embedded_field_2',
        'copy_field'      => 'copy_field',
    ),
);

$v = new cqCopyFieldsToEmbeddedFormValidatorSchema(null, array(
    'fields_to_copy' => 'copy_field',
    'embedded_form_names' => array('embedded_form_1', 'embedded_form_2'),
));


$t->is_deeply($v->clean($values), $expected_result,
  '::clean() properly copies the fields to the embedded forms');


$v->setOption('remove_on_copy', true);
$t->is_deeply($v->clean($values), $expected_result_with_remove_on_copy,
  '::clean() properly copies the fields to the embedded forms and removes them from the original with "remove_on_copy" option set');


