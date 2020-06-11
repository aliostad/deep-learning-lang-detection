Rails.application.routes.draw do
  
  # API
    match '/api/register_account' => 'api#registerAccount', via: [:get, :post]
    match '/api/registerAccount' => 'api#registerAccount', via: [:get, :post]
    
    match '/api/login' => 'api#login', via: [:get, :post]
    match '/api/get_locations' => 'api#get_locations', via: [:get, :post]
    match '/api/submit_location_review' => 'api#submit_location_review', via: [:get, :post]
    match '/api/get_location_reviews' => 'api#get_location_reviews', via: [:get, :post]
    match '/api/update_profile' => 'api#update_profile', via: [:get, :post]
    match '/api/get_self_json' => 'api#get_self_json', via: [:get, :post]
    match '/api/get_circles' => 'api#get_circles', via: [:get, :post]
    match '/api/create_circle' => 'api#create_circle', via: [:get, :post]
    match '/api/add_user_to_circle' => 'api#add_user_to_circle', via: [:get, :post]
    match '/api/remove_user_from_circle' => 'api#remove_user_from_circle', via: [:get, :post]
    match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    match '/api/find_friends' => 'api#find_friends', via: [:get, :post]
    match '/api/add_friend' => 'api#add_friend', via: [:get, :post]
    match '/api/confirm_friend_request' => 'api#confirm_friend_request', via: [:get, :post]
    match '/api/get_wall' => 'api#get_wall', via: [:get, :post]
    match '/api/get_friends' => 'api#get_friends', via: [:get, :post]
    match '/api/get_user_info' => 'api#get_user_info', via: [:get, :post]
    match '/api/get_location_info' => 'api#get_location_info', via: [:get, :post]
    match '/api/get_offers' => 'api#get_offers', via: [:get, :post]
    match '/api/reset_password' => 'api#reset_password', via: [:get, :post]
    match '/api/upload_review_photo' => 'api#upload_review_photo', via: [:get, :post]
    match '/api/find_users' => 'api#find_users', via: [:get, :post]
    match '/api/follow_user' => 'api#follow_user', via: [:get, :post]
    match '/api/unfollow_user' => 'api#unfollow_user', via: [:get, :post]
    match '/api/get_circle_activity' => 'api#get_circle_activity', via: [:get, :post]
    match '/api/update_user_data' => 'api#update_user_data', via: [:get, :post]
    
    match '/api/get_likes' => 'api#get_likes', via: [:get, :post]
    match '/api/like_post' => 'api#like_post', via: [:get, :post]
    match '/api/unlike_post' => 'api#unlike_post', via: [:get, :post]
    
    match '/api/get_user_messages' => 'api#get_user_messages', via: [:get, :post]
    
    match '/api/get_followers' => 'api#get_followers', via: [:get, :post]
    
    match '/api/invite_circles_to_location' => 'api#invite_circles_to_location', via: [:get, :post]
    
    
    match '/api/get_more_wall' => 'api#get_more_wall', via: [:get, :post]
    
    match '/api/followerCount' => 'api#followerCount', via: [:get, :post]
    match '/api/search_followers' => 'api#search_followers', via: [:get, :post]
    
    match '/api/send_new_password' => 'api#send_new_password', via: [:get, :post]
    
    match '/api/create_venue' => 'api#create_venue', via: [:get, :post]
    match '/api/import_from_4' => 'api#import_from_4', via: [:get, :post]
    match '/api/upload_avatar' => 'api#upload_avatar', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]
    #match '/api/remove_circle' => 'api#remove_circle', via: [:get, :post]

    
    
    match '/api/all_user_ids' => 'api#all_user_ids', via: [:get, :post]
    match '/api/devRun' => 'api#devRun', via: [:get, :post]
  
end

