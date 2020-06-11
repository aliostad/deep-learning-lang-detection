require 'spec_helper'

describe RegisterRepository do
  subject { RegisterRepository.call(register_repository_params) }
  let(:user) { create(:user) }

  describe "with valid payload" do
    let(:register_repository_params) do
      {
        link: SITES["main_example"],
        user_id: user.id
      }
    end

    use_vcr_cassette "main_example"

    it "works and associates user to repository" do
      expect {
        subject
      }.to change{Repository.count}.by(1)

      repository = Repository.find_by_link(register_repository_params[:link])

      repository.user.should eq user
    end
  end
end
