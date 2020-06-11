FactoryGirl.define do
  trait :metasploit_cache_payload_handable_handler do
    transient do
      # for passing to :metasploit_cache_payload_handler_module trait
      handler_load_pathname nil
    end

    handler {
      if handler_load_pathname.nil?
        raise ArgumentError,
              ':handler_load_pathname must be set for :metasploit_cache_payload_handable_handler trait so it can set ' \
              ':load_pathname for :metasploit_cache_payload_handler_module trait'
      end

      build(
          :full_metasploit_cache_payload_handler,
          load_pathname: handler_load_pathname
      )
    }
  end
end