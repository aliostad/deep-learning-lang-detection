class Api::V1::ApiError < StandardError
  def initialize(code, msg)
    @api_code = code
    @api_msg = msg
    super(msg)
  end

  def api_code
    @api_code
  end

  def api_msg
    @api_msg
  end

  def self.generic_error
    Api::V1::ApiError.new(400, 'Bad request')
  end

  def self.invalid_user
    Api::V1::ApiError.new(600, 'Invalid credentials')
  end

  def self.missing_param(name)
    Api::V1::ApiError.new(601, "Missing required param : #{name}")
  end

  def self.invalid_signature()
    Api::V1::ApiError.new(602, "Invalid signature")
  end

  def self.invalid_ts()
    Api::V1::ApiError.new(603, "Timestamp too old")
  end

  def self.user_exist
    Api::V1::ApiError.new(604, "User already exist")
  end

  def self.error_creating_exist
    Api::V1::ApiError.new(605, "Error creating user")
  end
end