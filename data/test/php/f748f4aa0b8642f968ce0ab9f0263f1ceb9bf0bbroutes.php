<?php

header("Content-Type: application/json; charset=utf-8");

if ($request === "/api/auth") {
  require_once "api_auth.php";
} else if ($request === "/api/posts") {
  require_once "api_posts.php";
} else if ($request === "/api/post/save") {
  require_once "api_post_save.php";
} else if ($request === "/api/post/delete") {
  require_once "api_post_delete.php";
} else if ($request === "/api/post/likes") {
  require_once "api_post_likes.php";
} else if ($request === "/api/post/likes/add") {
  require_once "api_post_likes_add.php";
}  else if ($request === "/api/post/likes/delete") {
  require_once "api_post_likes_delete.php";
} else if ($request === "/api/media") {
  require_once "api_media.php";
} else if ($request === "/api/media/delete") {
  require_once "api_media_delete.php";
} else if ($request === "/api/users") {
  require_once "api_users.php";
} else if ($request === "/api/user/save") {
  require_once "api_user_save.php";
} else if ($request === "/api/user/delete") {
  require_once "api_user_delete.php";
} else if ($request === "/api/user/check") {
  require_once "api_user_check.php";
} else {
  error("404", "json");
}
