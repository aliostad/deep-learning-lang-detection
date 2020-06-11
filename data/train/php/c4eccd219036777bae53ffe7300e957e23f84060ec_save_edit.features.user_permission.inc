<?php

/**
 * Implementation of hook_user_default_permissions().
 */
function ec_save_edit_user_default_permissions() {
  $permissions = array();

  // Exported permission: administer save and edit
  $permissions['administer save and edit'] = array(
    'name' => 'administer save and edit',
    'roles' => array(),
  );

  // Exported permission: use save and edit
  $permissions['use save and edit'] = array(
    'name' => 'use save and edit',
    'roles' => array(
      '0' => 'authenticated user',
    ),
  );

  return $permissions;
}
