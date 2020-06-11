require 'spec_helper'
require './lib/memory_repository/project_repository'
require './lib/memory_repository/story_repository'
require './lib/memory_repository/user_repository'

describe MemoryRepository do
  it "has an project repo" do
    expect(MemoryRepository.project).to be_a MemoryRepository::ProjectRepository
  end

  it "has a story repo" do
    expect(MemoryRepository.story).to be_a MemoryRepository::StoryRepository
  end

  it "has a user repo" do
    expect(MemoryRepository.user).to be_a MemoryRepository::UserRepository
  end

end
