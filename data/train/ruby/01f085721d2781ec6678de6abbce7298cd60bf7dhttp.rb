module BOTR

	module HTTP

		def client
			@client = BOTR::HTTPBackend.new unless @client
			@client
		end

		def get_request(options = {})
			params = options.dup

			http      = params.delete(:client)        || client
			method    = params.delete(:method)
			url       = params.delete(:api_url)       || api_url(method)
			format    = params.delete(:api_format)    || api_format
			key       = params.delete(:api_key)       || api_key
			timestamp = params.delete(:api_timestamp) || api_timestamp
			nonce     = params.delete(:api_nonce)     || api_nonce
			secret    = params.delete(:api_secret_key)|| api_secret_key

			params = params.merge(:api_format    => format,
								  :api_key       => key,
								  :api_timestamp => timestamp,
								  :api_nonce     => nonce)

			http.get(url, params.merge(:api_signature => self.signature(params)))
		end

		def post_request(options = {}, data_path = nil)
			params = options.dup

			http      = params.delete(:client)        || client
			url       = params.delete(:api_url)    	  || upload_url
			format    = params.delete(:api_format)    || api_format
			key       = params.delete(:upload_key)    || upload_key
			token     = params.delete(:upload_token)  || upload_token

			params = params.merge(:api_format    => format,
								  :key           => key,
								  :token         => token)

			http.post(url, params, data_path)
		end

		def put_request(options = {})
			params = options.dup

			http      = params.delete(:client)        || client
			method    = 'update'
			url       = params.delete(:api_url)       || api_url(method)
			format    = params.delete(:api_format)    || api_format
			key       = params.delete(:api_key)       || api_key
			timestamp = params.delete(:api_timestamp) || api_timestamp
			nonce     = params.delete(:api_nonce)     || api_nonce
			secret    = params.delete(:api_secret_key)|| api_secret_key

			params = params.merge(:api_format    => format,
								  :api_key       => key,
								  :api_timestamp => timestamp,
								  :api_nonce     => nonce)

			http.post(url, params.merge(:api_signature => self.signature(params)))
		end

		def delete_request(options = {})
			params = options.dup

			http      = params.delete(:client)        || client
			method    = 'delete'
			url       = params.delete(:api_url)       || api_url(method)
			format    = params.delete(:api_format)    || api_format
			key       = params.delete(:api_key)       || api_key
			timestamp = params.delete(:api_timestamp) || api_timestamp
			nonce     = params.delete(:api_nonce)     || api_nonce
			secret    = params.delete(:api_secret_key)|| api_secret_key

			params = params.merge(:api_format    => format,
								  :api_key       => key,
								  :api_timestamp => timestamp,
								  :api_nonce     => nonce)

			http.post(url, params.merge(:api_signature => self.signature(params)))
		end

	end

end