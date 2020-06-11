class FootprintPublisher < Facebooker::Rails::Publisher
  helper :application

  # add footprint # here
  def calculate_feed_template
    calculate_back = link_to("Calculate your footprint!", 'calculator')
    # one_line_story_template "{*actor*} {*result*} {*defender*} with a {*move*}. #{attack_back}"
    one_line_story_template "{*actor*} calculated their environmental impact using Better Carbon. #{calculate_back}"
    short_story_template "{*actor*} calculated their environmental impact using Better Carbon.","#{calculate_back}"
  end
  
  def calculate_feed(facebook_session)
    send_as :user_action
    from facebook_session.user
    data :images=>[image("logo.gif", "calculate")]
  end
end
