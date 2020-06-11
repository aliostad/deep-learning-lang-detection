RSpec.describe Metasploit::Cache::Payload::Handler::Persister do
  context 'CONSTANTS' do
    context 'ATTRIBUTE_NAMES' do
      subject(:attribute_names) {
        described_class::ATTRIBUTE_NAMES
      }

      it { is_expected.to include :general_handler_type }
      it { is_expected.to include :handler_type }
    end
  end

  context 'attributes' do
    subject(:attributes) {
      described_class.attributes(source)
    }

    let(:general_handler_type) {
      FactoryGirl.generate :metasploit_cache_payload_handler_general_handler_type
    }

    let(:handler_type) {
      FactoryGirl.generate :metasploit_cache_payload_handler_handler_type
    }

    let(:name) {
      FactoryGirl.generate :metasploit_cache_payload_handler_name
    }

    context 'with Metasploit::Cache::Payload::Handler' do
      let(:source) {
        Metasploit::Cache::Payload::Handler.new(
            general_handler_type: general_handler_type,
            handler_type: handler_type,
            name: name
        )
      }

      it 'maps #general_handler_type to :general_handler_type' do
        expect(attributes[:general_handler_type]).to eq(general_handler_type)
      end

      it 'maps #handler_type to :handler_type' do
        expect(attributes[:handler_type]).to eq(handler_type)
      end

      it 'maps #name to :name' do
        expect(attributes[:name]).to eq(name)
      end
    end

    context 'with payload Metasploit Module handler_klass' do
      let(:source) {
        double(
            'payload Metasploit Module handler_klass',
            general_handler_type: general_handler_type,
            handler_type: handler_type,
            name: name
        )
      }

      it 'maps #general_handler_type to :general_handler_type' do
        expect(attributes[:general_handler_type]).to eq(general_handler_type)
      end

      it 'maps #handler_type to :handler_type' do
        expect(attributes[:handler_type]).to eq(handler_type)
      end

      it 'maps #name to :name' do
        expect(attributes[:name]).to eq(name)
      end
    end
  end
end