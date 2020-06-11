module AWeber
  module Resources
    class Followup < Resource
      api_attr :click_tracking_enabled
      api_attr :content_type
      api_attr :message_interval
      api_attr :message_number
      api_attr :spam_assassin_score
      api_attr :subject
      api_attr :total_clicked
      api_attr :total_opened
      api_attr :total_sent
      api_attr :total_spam_complaints
      api_attr :total_undelivered
      api_attr :total_unsubscribes

      api_attr :links_collection_link
      api_attr :messages_collection_link
      
      has_many :links
      has_many :messages
    end
  end
end