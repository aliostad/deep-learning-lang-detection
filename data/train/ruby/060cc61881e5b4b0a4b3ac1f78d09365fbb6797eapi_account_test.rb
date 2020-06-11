require "test_helper"

class ApiAccountTest < ActiveSupport::TestCase
  setup do
    @user        = User.create(uid: "1", provider: "twitter", name: "user")
    @api         = FactoryGirl.create(:api, :github)
    @api_account = ApiAccount.create!(user_id: @user.id, api_id: @api.id , api_username: "QuillyT")
  end

  test "it validates user_id" do
    assert @api_account.valid?, "Account Should Be Valid"
    @api_account.user_id = "b"
    refute @api_account.valid?
  end

  test "it validates api_id" do
    @api_account.api_id = "b"
    refute @api_account.valid?
  end

  test "it validates api_username" do
    VCR.use_cassette('check_valid_1') do
      @api_account.api_username = "jlak23sdjbre12"
      refute @api_account.api_account_exists
    end
  end
end
