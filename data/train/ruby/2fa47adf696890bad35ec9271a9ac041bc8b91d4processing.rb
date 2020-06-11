Dir[File.join(RAILS_ROOT, 'app', 'processors', '**', '*')].each {|f| require f }
Dir[File.join(RAILS_ROOT, 'app', 'handlers', '**', '*')].each {|f| require f }
HANDLERS = [
  Message::InviteHandler, 
  Message::HelpHandler, 
  Message::ChannelsHandler,
  Message::RemoveHandler,
  Message::ListHandler,
  Message::MoreHandler,
  Message::LessHandler,
  Message::LocaleHandler,
  Message::SleepHandler,
  Message::AwakeHandler,
  Message::RateHandler,
  Message::CommentHandler,
  Message::QuitHandler,
  Message::AddHandler
]