class ApiActionDescription
  include Mongoid::Document

  field :api_host, type: String
  field :api_version, type: String
  field :api_resource, type: String
  field :api_action, type: String
  field :description, type: String
  field :created_at, type: Time
  field :updated_at, type: Time

  validates :api_host, presence: true
  validates :api_version, presence: true
  validates :api_resource, presence: true
  validates :api_action, presence: true
  validates :description, presence: true

  index({api_host: 1, api_version: 1, api_resource: 1, api_action: 1}, unique: true)

  before_save :strip_carriage_returns

  def self.new_for_resource(api_action)
    api_action_description = new(api_host: api_action.api_host.name,
      api_version: api_action.api_version.name,
      api_resource: api_action.api_resource.name,
      api_action: api_action.name)
  end

  def strip_carriage_returns
    description.delete!("\r")
  end

end