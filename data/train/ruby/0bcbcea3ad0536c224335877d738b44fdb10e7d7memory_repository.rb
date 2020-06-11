require 'memory_repository/product_repository'
require 'memory_repository/user_repository'
require 'memory_repository/like_repository'
require 'memory_repository/nope_repository'

module MemoryRepository

  def self.product
    @product_repo ||= ProductRepository.new
  end

  def self.user
    @user_repo ||= UserRepository.new
  end

  def self.like
    @like_repo ||= LikeRepository.new
  end

  def self.nope
    @nope_repo ||= NopeRepository.new
  end

  def self.purge!
    product.destroy_all!
    user.destroy_all!
    like.destroy_all!
    nope.destroy_all!
  end

end
