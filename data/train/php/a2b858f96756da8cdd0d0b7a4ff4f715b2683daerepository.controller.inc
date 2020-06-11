<?php
/**
 * @file
 * Definition of ReporitoryController Class
 */
class RepositoryController extends DrupalDefaultEntityController {

  public function save($repository) {
    global $user;
    $repository->repo_uid = $user->uid;
    $repository->repo_timestamp = time();
    field_attach_presave('repository', $repository);
    if (!empty($repository->repo_id)) {
      drupal_write_record('repository', $repository, 'repo_id');
      field_attach_update('repository', $repository);
      module_invoke_all('entity_update', 'repository', $repository);
      return $repository;
    }
    drupal_write_record('repository', $repository);
    field_attach_insert('repository', $repository);
    module_invoke_all('entity_insert', 'repository', $repository);
    return $repository;
  }
}

