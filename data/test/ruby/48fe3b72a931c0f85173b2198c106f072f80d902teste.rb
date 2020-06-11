require '/home/bruno/Cabuum/Projects/SmileAPI/smile_api/lib/config.rb'
require '/home/bruno/Cabuum/Projects/SmileAPI/smile_api/lib/connection.rb'
require '/home/bruno/Cabuum/Projects/SmileAPI/smile_api/lib/message.rb'
require '/home/bruno/Cabuum/Projects/SmileAPI/smile_api/lib/message_entity.rb'
require '/home/bruno/Cabuum/Projects/SmileAPI/smile_api/lib/type_message.rb'
require '/home/bruno/Cabuum/Projects/SmileAPI/smile_api/lib/profile.rb'

profile = SmileAPI::Profile.new "John", "crazy", "M", Time.new("1996-01-01"), SmileAPI::Config.new("cabuum")
h = SmileAPI::MessageEntity.new "pt-BR", [ "cadastro" ], SmileAPI::TypeMessage::SUCCESS, profile

msg = SmileAPI::Message.getMessage h