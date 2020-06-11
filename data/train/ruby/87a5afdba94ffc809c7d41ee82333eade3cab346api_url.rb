module TwitterCui
  module Api_Url
    Host = "https://api.twitter.com"
    Api_Version = "1.1"
    Api_Url = "#{Host}/#{Api_Version}"

    User_Timeline       = "#{Api_Url}/statuses/user_timeline.json"
    Home_Timeline       = "#{Api_Url}/statuses/home_timeline.json"
    Mentions_Timeline   = "#{Api_Url}/statuses/mentions_timeline.json"
    Statuses_Update     = "#{Api_Url}/statuses/update.json"
    Followers_List      = "#{Api_Url}/followers/list.json"
    Followers_Ids       = "#{Api_Url}/followers/ids.json"
    Users_Show          = "#{Api_Url}/users/show.json"
    Friends_Ids         = "#{Api_Url}/friends/ids.json"
    Friendships_Create  = "#{Api_Url}/friendships/create.json"
    Friendships_Destroy = "#{Api_Url}/friendships/destroy.json"

    User_Stream = "https://userstream.twitter.com/2/user.json"
  end
end
