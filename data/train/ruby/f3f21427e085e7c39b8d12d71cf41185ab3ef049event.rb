class Event
  API_WISHLIST_LOAD         = 1
  API_WISHLIST_CREATE       = 2
  API_WISHLIST_DESTROY      = 3
  API_ACTIVITY_LOAD         = 4
  API_NONCE_FETCH           = 5
  API_LOGIN                 = 6
  API_LOGOUT                = 7
  API_PLACE_LOAD            = 8
  API_PLACE_SEARCH          = 9
  API_EXCEPTION             = 10
  API_NOTE_CREATE           = 11
  WELCOME_SCREEN_VIEW       = 12
  SUBSCRIBE_SCREEN_VIEW     = 13
  CONTINUE_SCREEN_VIEW      = 14
  GO_TO_WISHLIST_SELECT     = 15
  GO_TO_ACTIVITY_SELECT     = 16
  GO_TO_EXPERIENCES_SELECT  = 17
  
  uniq_constants!
  
  def self.lookup(string)
    const_get(string.gsub(/\s/, "_").upcase)
  end
end