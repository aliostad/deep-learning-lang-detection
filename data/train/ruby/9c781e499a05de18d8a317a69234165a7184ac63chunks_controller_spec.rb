require 'spec_helper'

describe ChunksController do
	let(:user) { FactoryGirl.create(:user) }
	
	describe "POST #event" do
		before { @chunk = FactoryGirl.create(:chunk) }
		describe "as right user" do
			before do
      			sign_in(user, no_capybara: true)
				get :event, id: @chunk, event_id: "0"
			end

			it "update the chunk status" do
				expect(@chunk.status_id).to eq(1)
			end

			it "redirects to the root page" do
				expect(response).to redirect_to(root_url)
			end
		end

		describe "as wrong user" do
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { @chunk = FactoryGirl.create(:chunk) }
			before do
      			sign_in(wrong_user, no_capybara: true)
				get :event, id: @chunk, event_id: 0
			end

			it "shouldn't update the chunk status" do
				expect(@chunk.status_id).to eq(0)
			end
			it "redirects to the root page" do
				expect(response).to redirect_to(root_url)
			end
			it "shows an error message" do
				flash[:warning].should eql('Wrong user')
			end
		end
	end

	describe "DELETE destroy" do
		before { @chunk = FactoryGirl.create(:chunk) }
		it "deletes the chunk" do
			expect {
				delete :destroy, id: @chunk
			}.to change(Chunk, :count).by(-1)
		end
	end
end