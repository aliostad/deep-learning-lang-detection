<?php

/**
 * Impolementation of the Disqus API designed for Omeka
 *
 * @author Scholars' Lab
 * @copyright 2011
 * @link http://disqus.com
 * @package Disqus
 * @subpackage DisqusOmekaAPI
 * @version 0.1
 */

require_once(dirname(__FILE__) . '/api/disqus/disqus.php');

/**
 * @#+
 * Constants
 */
/**
 * Allowable HTML tags
 */
define('DISQUS_ALLOWED_HTML', '<b><b><u><i><h1><h2><h3><code><blockquote><br><hr>');

/**
 * Helper methods for all the Disqus v2 API methods
 * 
 * @package Disqus
 * @subpackage DisqusOmekaAPI
 * @author Scholars' Lab
 * @copyright 2011
 * @version 0.1
 */
class DisqusOmekaAPI {
  var $short_name;
  var $forum_api_key;

  function __construct($short_name=null, $forum_api_key=null, $user_api_key=null) {
		$this->short_name = $short_name;
		$this->forum_api_key = $forum_api_key;
		$this->user_api_key = $user_api_key;
		$this->api = new DisqusAPI($user_api_key, $forum_api_key, DISQUS_API_URL);
  }

  /**
   * Return the last error
   * @see 
   * @return string Last error
   */
  function getLastError()
  {
    return $this->api->get_last_error();
  }

  /**
   * Return a user's api key
   */
  function getUserApiKey($username, $password)
  {
    $response = $this->api->call('get_user_api_key', array(
      'username' => $username,
      'password' => $password,
    ), true);

    return $response;
  }

  /**
   * Return the forum list for a user
   */
  function getForumList($user_api_key)
  {
    $this->api->user_api_key = $user_api_key;
    return $this->api->get_forum_list();
  }

  /**
   * Return a forum API key
   */
  function getForumApiKey($user_api_key, $id)
  {
    $this->api->user_api_key = $user_api_key;
    return $this->api->getForumApiKey($id);
  }

  function getForumPosts($start_id = 0)
  {
    $response = $this->api->getForumPosts(null, array(
      'filter' => 'approved',
      'start_id' => $start_id,
      'limit' => 100,
      'order' => 'asc',
      'full_info' => 1
    ));
    return $response;
  }

}
