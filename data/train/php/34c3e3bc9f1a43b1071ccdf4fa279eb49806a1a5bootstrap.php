<?php
/**
 * 
 */

\Fuel\Core\Autoloader::add_classes(array(
    'Github\\Exception\\Exception_Api_Limit' " 123"              => __DIR__.'/classes/exception/api/limit.php',
    'Github\\Exception\\Exception_Argument_Invalid'        => __DIR__.'/classes/exception/argument/invalid.php',
    'Github\\Exception\\Exception_Argument_Missing'        => __DIR__.'/classes/exception/argument/missing.php',

    'Github\\Client'                            => __DIR__.'/classes/client.php',

    'Github\\Api\\Api_Interface'                => __DIR__.'/classes/api/api_interface.php',
    'Github\\Api\\Abstract_Api'                 => __DIR__.'/classes/api/abstract/api.php',

    'Github\\Api\\Current_User'                 => __DIR__.'/classes/api/current_user.php',
    'Github\\Api\\Current_User\\Deploy_Keys'    => __DIR__.'/classes/api/current_user/deploy_keys.php',
    'Github\\Api\\Current_User\\Emails'         => __DIR__.'/classes/api/current_user/emails.php',
    'Github\\Api\\Current_User\\Followers'      => __DIR__.'/classes/api/current_user/followers.php',
    'Github\\Api\\Current_User\\Watchers'       => __DIR__.'/classes/api/current_user/watchers.php',

    'Github\\Api\\Event'                        => __DIR__.'/classes/api/event.php',

    'Github\\Api\\Git_Data'                     => __DIR__.'/classes/api/git_data.php',
    'Github\\Api\\Git_Data\\Blobs'              => __DIR__.'/classes/api/git_data/blobs.php',
    'Github\\Api\\Git_Data\\Commits'            => __DIR__.'/classes/api/git_data/commits.php',
    'Github\\Api\\Git_Data\\References'         => __DIR__.'/classes/api/git_data/references.php',
    'Github\\Api\\Git_Data\\Tags'               => __DIR__.'/classes/api/git_data/tags.php',
    'Github\\Api\\Git_Data\\Trees'              => __DIR__.'/classes/api/git_data/trees.php',

    'Github\\Api\\Issue'                        => __DIR__.'/classes/api/issue.php',
    'Github\\Api\\Issue\\Comments'              => __DIR__.'/classes/api/issue/comments.php',
    'Github\\Api\\Issue\\Events'                => __DIR__.'/classes/api/issue/events.php',
    'Github\\Api\\Issue\\Label'                 => __DIR__.'/classes/api/issue/label.php',
    'Github\\Api\\Issue\\Milestones'            => __DIR__.'/classes/api/issue/milestones.php',

    'Github\\Api\\Markdown'                     => __DIR__.'/classes/api/markdown.php',

    'Github\\Api\\Organisation'                 => __DIR__.'/classes/api/organisation.php',
    'Github\\Api\\Organisation\\Members'        => __DIR__.'/classes/api/organisation/members.php',
    'Github\\Api\\Organisation\\Teams'          => __DIR__.'/classes/api/organisation/teams.php',

    'Github\\Api\\Pull_Request'                 => __DIR__.'/classes/api/pull_request.php',
    'Github\\Api\\Pull_Request\\Comments'       => __DIR__.'/classes/api/pull_request/comments.php',

    'Github\\Api\\Repository'                   => __DIR__.'/classes/api/repository.php',
    'Github\\Api\\Repository\\Collaborators'    => __DIR__.'/classes/api/repository/collaborators.php',
    'Github\\Api\\Repository\\Comments'         => __DIR__.'/classes/api/repository/comments.php',
    'Github\\Api\\Repository\\Commits'          => __DIR__.'/classes/api/repository/commits.php',
    'Github\\Api\\Repository\\Contents'         => __DIR__.'/classes/api/repository/contents.php',
    'Github\\Api\\Repository\\Deploy_Keys'      => __DIR__.'/classes/api/repository/deploy_keys.php',
    'Github\\Api\\Repository\\Downloads'        => __DIR__.'/classes/api/repository/downloads.php',
    'Github\\Api\\Repository\\Forks'            => __DIR__.'/classes/api/repository/forks.php',
    'Github\\Api\\Repository\\Hooks'            => __DIR__.'/classes/api/repository/hooks.php',
    'Github\\Api\\Repository\\Labels'           => __DIR__.'/classes/api/repository/labels.php',


    'Github\\Api\\User'                     => __DIR__.'/classes/api/user.php',
));

/* End of file bootstrap.php */