# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

module SendGrid4r::REST::ApiKeysManagement
  describe SendGrid4r::REST::ApiKeysManagement do
    describe 'integration test', :it do
      before do
        Dotenv.load
        @client = SendGrid4r::Client.new(api_key: ENV['SILVER_API_KEY'])
        @name1 = 'api_key_name1'
        @name2 = 'api_key_name2'
        @name1e = 'api_key_name1_edit'

        # celan up test env(lists)
        api_keys = @client.get_api_keys
        api_keys.result.each do |api_key|
          @client.delete_api_key(
            api_key_id: api_key.api_key_id
          ) if api_key.name == @name1
          @client.delete_api_key(
            api_key_id: api_key.api_key_id
          ) if api_key.name == @name2
          @client.delete_api_key(
            api_key_id: api_key.api_key_id
          ) if api_key.name == @name1e
        end

        # post api_key
        @api_key1 = @client.post_api_key(name: @name1, scopes: ['mail.send'])
      end

      context 'without block call' do
        it '#get_api_keys' do
          api_keys = @client.get_api_keys
          expect(api_keys).to be_a(ApiKeys)
          expect(api_keys.result).to be_a(Array)
        end

        it '#post_api_key' do
          api_key2 = @client.post_api_key(name: @name2)
          expect(api_key2).to be_a(ApiKey)
          expect(api_key2.name).to eq(@name2)
          expect(api_key2.api_key_id).to be_a(String)
          expect(api_key2.api_key).to be_a(String)
        end

        it '#post_api_key with scopes' do
          api_key2 = @client.post_api_key(name: @name2, scopes: ['mail.send'])
          expect(api_key2).to be_a(ApiKey)
          expect(api_key2.name).to eq(@name2)
          expect(api_key2.api_key_id).to be_a(String)
          expect(api_key2.api_key).to be_a(String)
          expect(api_key2.scopes).to be_a(Array)
        end

        it '#get_api_key' do
          api_key = @client.get_api_key(api_key_id: @api_key1.api_key_id)
          expect(api_key).to be_a(ApiKey)
          expect(api_key.api_key_id).to eq(@api_key1.api_key_id)
          expect(api_key.name).to eq('api_key_name1')
          expect(api_key.scopes).to be_a(Array)
        end

        it '#delete_api_key' do
          @client.delete_api_key(api_key_id: @api_key1.api_key_id)
        end

        it '#patch_api_key' do
          edit_api_key = @client.patch_api_key(
            api_key_id: @api_key1.api_key_id, name: @name1e
          )
          expect(edit_api_key.api_key_id).to eq(@api_key1.api_key_id)
          expect(edit_api_key.name).to eq(@name1e)
        end

        it '#put_api_key' do
          edit_api_key = @client.put_api_key(
            api_key_id: @api_key1.api_key_id,
            name: @name1e,
            scopes: ['mail.send']
          )
          expect(edit_api_key.api_key_id).to eq(@api_key1.api_key_id)
          expect(edit_api_key.name).to eq(@name1e)
          expect(edit_api_key.scopes).to eq(['mail.send'])
        end
      end
    end

    describe 'unit test', :ut do
      let(:client) do
        SendGrid4r::Client.new(api_key: '')
      end

      let(:api_keys) do
        '{'\
          '"result": ['\
            '{'\
              '"name": "A New Hope",'\
              '"api_key_id": "xxxxxxxx"'\
            '}'\
          ']'\
        '}'
      end

      let(:api_key) do
        '{'\
          '"api_key": "SG.xxxxxxxx.yyyyyyyy",'\
          '"api_key_id": "xxxxxxxx",'\
          '"name": "My API Key",'\
          '"scopes": ['\
            '"mail.send",'\
            '"alerts.create",'\
            '"alerts.read"'\
          ']'\
        '}'
      end

      it '#get_api_keys' do
        allow(client).to receive(:execute).and_return(api_keys)
        actual = client.get_api_keys
        expect(actual).to be_a(ApiKeys)
      end

      it '#post_api_key' do
        allow(client).to receive(:execute).and_return(api_key)
        actual = client.post_api_key(name: '')
        expect(actual).to be_a(ApiKey)
      end

      it '#delete_api_key' do
        allow(client).to receive(:execute).and_return('')
        actual = client.delete_api_key(api_key_id: '')
        expect(actual).to eq('')
      end

      it '#patch_api_key' do
        allow(client).to receive(:execute).and_return(api_key)
        actual = client.patch_api_key(api_key_id: '', name: '')
        expect(actual).to be_a(ApiKey)
      end

      it '#put_api_key' do
        allow(client).to receive(:execute).and_return(api_key)
        actual = client.put_api_key(api_key_id: '', name: '', scopes: [])
        expect(actual).to be_a(ApiKey)
      end

      it 'creates api_key instance' do
        actual = SendGrid4r::REST::ApiKeysManagement.create_api_key(
          JSON.parse(api_key)
        )
        expect(actual).to be_a(ApiKey)
        expect(actual.api_key).to eq('SG.xxxxxxxx.yyyyyyyy')
        expect(actual.api_key_id).to eq('xxxxxxxx')
        expect(actual.name).to eq('My API Key')
        expect(actual.scopes).to eq(
          ['mail.send', 'alerts.create', 'alerts.read']
        )
      end

      it 'creates api_keys instance' do
        actual = SendGrid4r::REST::ApiKeysManagement.create_api_keys(
          JSON.parse(api_keys)
        )
        expect(actual).to be_a(ApiKeys)
        expect(actual.result).to be_a(Array)
        actual.result.each do |api_key|
          expect(api_key.name).to eq('A New Hope')
          expect(api_key.api_key_id).to eq('xxxxxxxx')
        end
      end
    end
  end
end
