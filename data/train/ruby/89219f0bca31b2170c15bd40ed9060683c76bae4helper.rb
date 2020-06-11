module Gcfs
  module Wrapper
    module Api

      module Helper
        def authenticate_gcfs_api
          gcfs_api_token = fetch_gcfs_api_token

          unless gcfs_api_token.present? and Gcfs::Wrapper::Api::Status.get_stat.kind_of?(Gcfs::Wrapper::Api::Status)
            gcfs_api_token = refetch_gcfs_api_token
          end

          Gcfs::Wrapper::Api.token = Gcfs::Wrapper::Api::Token.new gcfs_api_token.as_hash
        end

        def fetch_gcfs_api_token
          Rails.cache.fetch('GCFS_API_TOKEN', expires_in: 1.hour) { Gcfs::Wrapper::Api::Token.request }
        end

        def refetch_gcfs_api_token
          Rails.cache.delete('GCFS_API_TOKEN')
          fetch_gcfs_api_token
        end
      end

    end
  end
end