module Google
  class SafeBrowsingShavar < ActiveRecord::Base
    
    CHUNK_TYPE_ADD ||= 'a'
    CHUNK_TYPE_SUB ||= 's'
  
    belongs_to :list, :class_name => "Google::SafeBrowsingList", :foreign_key => "google_safe_browsing_list_id"
  
    scope :add_chunk_nums_for_list, lambda {|list_name|
      joins("join google_safe_browsing_lists as lists on lists.id = google_safe_browsing_shavars.google_safe_browsing_list_id")
         .where("lists.name = ?", list_name)
         .where('google_safe_browsing_shavars.chunk_type = ?', CHUNK_TYPE_ADD)
         .group("google_safe_browsing_shavars.chunk_num")
         .order('google_safe_browsing_shavars.chunk_num')
    }

    scope :sub_chunk_nums_for_list, lambda {|list_name|
      joins("join google_safe_browsing_lists as lists on lists.id = google_safe_browsing_shavars.google_safe_browsing_list_id")
         .where("lists.name = ?", list_name)
         .where('google_safe_browsing_shavars.chunk_type = ?', CHUNK_TYPE_SUB)
         .group("google_safe_browsing_shavars.chunk_num")
         .order('google_safe_browsing_shavars.chunk_num')
    }

    scope :add_host_keys, lambda { |hashes|
      where(chunk_type: CHUNK_TYPE_ADD, host_key: hashes)
    }
    
    scope :add_host_prefixes, lambda { |hosts, prefixes|
      where(chunk_type: CHUNK_TYPE_ADD, host_key: hosts, prefix: prefixes)
    }

    def self.find_subs_for_add add_chunk_num, host_key, prefix
      where(chunk_type: CHUNK_TYPE_SUB, add_chunk_num: add_chunk_num, host_key: host_key, prefix: prefix)
    end
    
  end  
end