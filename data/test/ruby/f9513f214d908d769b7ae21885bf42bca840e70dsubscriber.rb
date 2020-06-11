module AWeber
  module Resources
    class Subscriber < Resource
      api_attr :name,          :writable => true
      api_attr :misc_notes,    :writable => true
      api_attr :email,         :writable => true
      api_attr :status,        :writable => true
      api_attr :custom_fields, :writable => true
      api_attr :ad_tracking,   :writable => true
      api_attr :last_followup_message_number_sent, :writable => true
      
      api_attr :ip_address
      api_attr :is_verified
      api_attr :last_followup_sent_at
      api_attr :subscribed_at
      api_attr :subscription_method
      api_attr :subscription_url
      api_attr :unsubscribed_at
      api_attr :verified_at
      api_attr :last_followup_sent_link
      
      has_one :last_followup_sent
      
      alias_attribute :is_verified?, :is_verified
      alias_attribute :notes, :misc_notes
    end
  end
end