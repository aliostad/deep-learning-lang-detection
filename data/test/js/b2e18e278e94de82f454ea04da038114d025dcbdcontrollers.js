define([
    'js/lib/nuclearHorseStudios/controllers/recentBlogPostsController',
    'js/lib/nuclearHorseStudios/controllers/blogAddPostController',
    'js/lib/nuclearHorseStudios/controllers/blogViewPostController',
    'js/lib/nuclearHorseStudios/controllers/blogDeletePostController',
    'js/lib/nuclearHorseStudios/controllers/blogAdminController',
    'js/lib/nuclearHorseStudios/controllers/blogPostsPaginatedController',
    'js/lib/nuclearHorseStudios/controllers/adminController',
    'js/lib/nuclearHorseStudios/controllers/creationsController',
    'js/lib/nuclearHorseStudios/controllers/contactController',
    'js/lib/nuclearHorseStudios/controllers/loginController',
    'js/lib/nuclearHorseStudios/controllers/twitterController',
    'js/lib/nuclearHorseStudios/controllers/faqController'], 

    function(
        RecentBlogPosts,
        BlogAddPostController,
        BlogViewPostController,
        BlogDeletePostController,
        BlogAdminController,
        BlogPostsPaginatedController,
        AdminController,
        CreationsController,
        ContactController,
        LoginController,
        TwitterController,
        FaqController
    ) {
        
        return {
            RecentBlogPosts:              RecentBlogPosts,
            BlogAddPostController:        BlogAddPostController,
            BlogViewPostController:       BlogViewPostController,
            BlogDeletePostController:     BlogDeletePostController,
            BlogAdminController:          BlogAdminController,
            BlogPostsPaginatedController: BlogPostsPaginatedController,
            AdminController:              AdminController,
            CreationsController:          CreationsController,
            ContactController:            ContactController,
            LoginController:              LoginController,
            TwitterController:            TwitterController,
            FaqController:                FaqController
        };
});