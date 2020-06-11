class Friendship < ActiveRecord::Base
  belongs_to :fan, :foreign_key => 'user_id', :class_name => 'User'
  belongs_to :friend, :foreign_key => 'friend_user_id', :class_name => 'User'
  attr_protected :created_at

  def after_create
    calculate_friend_stats
    ETTriggeredSendAdd.send_new_fan_notification(self.friend, self.fan) if friend.notify_on_new_fan?
    UserActivity.befriended self
  end
  
  def after_destroy
    calculate_friend_stats
  end
    
private

  def calculate_friend_stats
    friend.stat.calculate_fans
    fan.stat.calculate_friends
  end
    
end
