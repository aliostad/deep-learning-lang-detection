<?php

namespace Ology\SocialBundle\Service;

class ApplicationManagerService {
    private static $isInit = false;
    
    private static $ologyService;
    private static $postService;
    private static $commentService;
    private static $notificationService;
    private static $membershipService;
    
    public function __construct(OlogyService $ologyService,
                                PostService $postService,
                                CommentService $commentService,
                                NotificationService $notificationService,
                                MembershipService $membershipService) {
        self::$ologyService = $ologyService;
        self::$postService = $postService;
        self::$commentService = $commentService;
        self::$notificationService = $notificationService;
        self::$membershipService = $membershipService;
    }
    
    public static function initApplication() {
        if (self::$isInit)
            return true;
        
        self::$ologyService->setNotificationService(self::$notificationService);
        self::$postService->setNotificationService(self::$notificationService);
        self::$commentService->setNotificationService(self::$notificationService);
        self::$membershipService->setNotificationService(self::$notificationService);
        self::$isInit = true;
    }
}

?>
