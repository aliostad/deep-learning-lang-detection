require 'spec_helper'
require 'memory_repository/memory_repository'
require 'memory_repository/product_repository'
require 'memory_repository/user_repository'
require 'memory_repository/like_repository'

RSpec.describe MemoryRepository do
  it 'has a product repository' do
    expect(MemoryRepository.product).to be_a(MemoryRepository::ProductRepository)
  end

  it 'has a user repository' do
    expect(MemoryRepository.user).to be_a(MemoryRepository::UserRepository)
  end

  it 'has a like repository' do
    expect(MemoryRepository.like).to be_a(MemoryRepository::LikeRepository)
  end

  it 'has a nope repository' do
    expect(MemoryRepository.nope).to be_a(MemoryRepository::NopeRepository)
  end
end
