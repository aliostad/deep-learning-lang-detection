require 'spec_helper'

describe "Chunk pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "chunk creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a chunk" do
        expect { click_button "Post" }.not_to change(Chunk, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'chunk_description', with: "Lorem ipsum" }
      it "should create a chunk" do
        expect { click_button "Post" }.to change(Chunk, :count).by(1)
      end
    end
  end
end