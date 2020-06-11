class TuanUrl < ActiveRecord::Base
  belongs_to :tuan_api
  validates :name,:presence => true,:uniqueness => true,:on => :create
  validates :url,:uniqueness => true,:on => :create
  attr_accessor :tuan_api_name
  before_validation :find_tuan_api

  scope :enables,where(:enable => 1).includes(:tuan_api)
  def docfind
    self.tuan_api.docfind
  end
  def suite
    self.tuan_api.suite
  end
  private
  def find_tuan_api
    self.tuan_api = TuanApi.where(:name => self.tuan_api_name).first if self.tuan_api_name
  end
end
