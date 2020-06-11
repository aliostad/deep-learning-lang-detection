<?php
include_once ('RennClientBase.php');
//include_once ('service/ShareService.php');
include_once ('service/StatusService.php');
//include_once ('service/AlbumService.php');
//include_once ('service/UbbService.php');
//include_once ('service/NotificationService.php');
include_once ('service/FeedService.php');
//include_once ('service/BlogService.php');
//include_once ('service/PhotoService.php');
include_once ('service/UserService.php');
//include_once ('service/ProfileService.php');

class RennClient extends RennClientBase {
        private $statusService;
        private $feedService;
        private $userService;
        
        function getStatusService() {
                if (empty ($this -> statusService )) {
                        $this->statusService = new StatusService ( $this, $this->accessToken );
                }
                return $this->statusService;
        }
        
        function getFeedService() {
                if (empty ($this -> feedService )) {
                        $this->feedService = new FeedService ( $this, $this->accessToken );
                }
                return $this->feedService;
        }
        
        function getUserService() {
                if (empty ($this -> userService )) {
                        $this->userService = new UserService ( $this, $this->accessToken );
                }
                return $this->userService;
        }
        
}
?>
