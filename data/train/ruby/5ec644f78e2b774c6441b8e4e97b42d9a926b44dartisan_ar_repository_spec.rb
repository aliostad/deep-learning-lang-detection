require 'spec_helper'
require 'artisan_ar_repository'

describe ArtisanArRepository do
  it "has a story repo" do
    ArtisanArRepository.story.should be_a ArtisanArRepository::StoryRepository
  end

  it "has a project repo" do
    ArtisanArRepository.project.should be_a ArtisanArRepository::ProjectRepository
  end

  it "has a iteration repo" do
    ArtisanArRepository.iteration.should be_a ArtisanArRepository::IterationRepository
  end

  it "has a future user repo" do
    ArtisanArRepository.future_user.should be_a ArtisanArRepository::FutureUserRepository
  end
  
  it "has a user repo" do
    ArtisanArRepository.user.should be_a ArtisanArRepository::UserRepository
  end

  it "has a member repo" do
    ArtisanArRepository.member.should be_a ArtisanArRepository::MemberRepository
  end

  it "has a project_configuration repo" do
    ArtisanArRepository.project_configuration.should be_a ArtisanArRepository::ProjectConfigurationRepository
  end
  
  it "has a change repo" do
    ArtisanArRepository.change.should be_a ArtisanArRepository::ChangeRepository
  end
end
