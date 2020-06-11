require 'test_helper'
require 'nixus_api'
require 'nixus_security'

class ApiCredentialTest < ActiveSupport::TestCase
	test "a valid api_id should be present after initialization" do
		api_cred = ApiCredential.new()
		assert_not api_cred.blank?, "the api_id was blank after initialization"
		assert_equal api_cred.api_id.length, NixusAPI::ID_SIZE, "the api_id has an invalid length"
		assert api_cred.api_id =~ /[A-Z0-9]{#{NixusAPI::ID_SIZE}}/, "the api_id has an invalid format"
	end

	test "api credentials should not be considered valid without an api_authenticable associated" do
		api_cred = ApiCredential.new()
		api_cred.valid?
		assert api_cred.api_authenticable.nil?, "the api_authenticable should be nil for this test"
		assert api_cred.errors[:api_authenticable].count > 0, "no errors were found for the api_authenticable attribute"
	end

	test "api_secret_hash should be valid after setting the api secret" do
		api_cred = ApiCredential.new()
		api_secret = api_cred.set_api_secret()
		assert_equal api_cred.api_secret_hash.length, NixusAPI::SECRET_HASH_SIZE, "the api_secret_hash has an invalid length"
	end

	test "the set_api_secret should return nil if the secret is already set" do
		api_cred = api_credentials(:valid_sample01)
		assert_nil api_cred.set_api_secret, "the api secret was already set and the set_api_secret method did not return nil"
	end

	test "api_id should not be tampered" do
		api_cred = api_credentials(:no_secret_hash01)
		api_cred.api_id = api_cred.api_id.reverse
		assert_not api_cred.save, "api_id was tampered and commited to database"
		assert_not api_cred.valid?, "api_id was tampered and the credential is still valid"
		assert api_cred.errors[:api_id].count > 0, "api_id was tempered but no errors concerning this were found"
	end
	
	test "api_secret_hash should not be tampered" do
		api_cred = api_credentials(:valid_sample01)
		api_cred.api_secret_hash = api_cred.api_secret_hash.reverse
		assert_not api_cred.save, "api_secret_hash was tampered and commited to database"
	end

	test "the validate_secret method should return true for a valid api_id x api_secret pair" do
		api_cred = ApiCredential.new()
		secret = api_cred.set_api_secret()
		assert_equal api_cred.validate_secret(secret), true, "the validate_secret method did not return true for a valid api_id x api_secret pair" 
	end
	
	test "the validate_secret method should return false for an invalid api_id x api_secret pair" do
		api_cred = ApiCredential.new()
		secret = api_cred.set_api_secret()
		assert_equal api_cred.validate_secret(secret.reverse), false, "the validate_secret method did not return true for a valid api_id x api_secret pair" 
	end
	#TODO:
	#Include reference check to api_authenticable
end
