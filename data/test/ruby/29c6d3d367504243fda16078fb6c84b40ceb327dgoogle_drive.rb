module GoogleDrive
  mattr_accessor :api_client_template

  def self.config(&block)
    yield(self)
  end

  def self.api
    @@api ||= @@api_client_template.discovered_api('drive', 'v2')
  end

  def self.generate_api_client access_token
    api_client = @@api_client_template.dup
    api_client.authorization.access_token = access_token
    api_client
  end

  def self.generate_authorization
    @@api_client_template.authorization.dup
  end

  def self.copy_file options
    copied_file_schema = api.files.copy.request_schema.new({title: options[:title]})
    api_client = generate_api_client(options[:access_token])

    return api_client.execute(
      api_method: api.files.copy,
      body_object: copied_file_schema,
      parameters: { fileId: options[:file_id] }
    )
  end

  def self.insert_permission options
    new_permission = api.permissions.insert.request_schema.new({
      value: options[:value],
      type: options[:type],
      role: options[:role],
      additionalRoles: options[:additional_roles]
    })
    api_client = generate_api_client(options[:access_token])

    return api_client.execute(
      api_method: api.permissions.insert,
      body_object: new_permission,
      parameters: { fileId: options[:file_id] }
    )
  end
end
