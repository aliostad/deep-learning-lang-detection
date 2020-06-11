require 'artisan-memory-repository/artisan_memory_repository'

describe ArtisanMemoryRepository do
  it "has a story repo" do
    ArtisanMemoryRepository.story.should be_a ArtisanMemoryRepository::StoryRepository
  end

  it "has a project repo" do
    ArtisanMemoryRepository.project.should be_a ArtisanMemoryRepository::ProjectRepository
  end

  it "has a iteration repo" do
    ArtisanMemoryRepository.iteration.should be_a ArtisanMemoryRepository::IterationRepository
  end

  it "has a user repo" do
    ArtisanMemoryRepository.user.should be_a ArtisanMemoryRepository::UserRepository
  end

  it "has a future user repo" do
    ArtisanMemoryRepository.future_user.should be_a ArtisanMemoryRepository::FutureUserRepository
  end

  it "has a change repo" do
    ArtisanMemoryRepository.change.should be_a ArtisanMemoryRepository::ChangeRepository
  end
end
