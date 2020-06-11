RSpec.describe Metasploit::Cache::Payload::Handable::Persister::Handler do
  context 'destination_attributes' do
    subject(:destination_attributes) {
      described_class.destination_attributes(destination)
    }

    context 'with new reccord' do
      let(:destination) {
        Metasploit::Cache::Payload::Single::Unhandled::Instance.new
      }

      it { is_expected.to eq({}) }
    end

    context 'with persisted record' do
      include_context ':metasploit_cache_payload_handler_module'
      include_context 'Metasploit::Cache::Spec::Unload.unload'

      #
      # lets
      #

      let(:destination) {
        FactoryGirl.create(
            :full_metasploit_cache_payload_single_unhandled_instance,
            handler_load_pathname: metasploit_cache_payload_handler_module_load_pathname
        )
      }

      it 'maps Metasploit::Cache::Payload::Handler#general_handler_type to :general_handler_type' do
        expect(destination_attributes[:general_handler_type]).to eq(destination.handler.general_handler_type)
      end

      it 'maps Metasploit::Cache::Payload::Handler#handler_type to :handler_type' do
        expect(destination_attributes[:handler_type]).to eq(destination.handler.handler_type)
      end
    end
  end

  context 'source_attributes' do
    subject(:source_attributes) {
      described_class.source_attributes(source)
    }

    let(:source) {
      double(
          'handled payload Metasploit Module instance',
          handler_klass: double(
              'payload Metasploit Module Handle Class',
              FactoryGirl.attributes_for(:metasploit_cache_payload_handler)
          )
      )
    }

    it 'maps #handler_klass #general_handler_type to :general_handler_type' do
      expect(source_attributes[:general_handler_type]).to eq(source.handler_klass.general_handler_type)
    end

    it 'maps #handler_klass #handler_type to :handler_type' do
      expect(source_attributes[:handler_type]).to eq(source.handler_klass.handler_type)
    end
  end

  context 'synchronize' do
    subject(:synchronize) {
      described_class.synchronize(
          destination: destination,
          logger: logger,
          source: source
      )
    }

    let(:logger) {
      double('Logger')
    }

    context 'with same attributes' do
      include_context ':metasploit_cache_payload_handler_module'
      include_context 'Metasploit::Cache::Spec::Unload.unload'

      #
      # lets
      #

      let(:destination) {
        FactoryGirl.create(
            :full_metasploit_cache_payload_single_unhandled_instance,
            handler_load_pathname: metasploit_cache_payload_handler_module_load_pathname
        )
      }

      let(:source) {
        handler = destination.handler

        double(
            'single payload Metasploit Module instance',
            handler_klass: double(
                'Metasploit Handler Class',
                general_handler_type: handler.general_handler_type,
                handler_type: handler.handler_type,
                name: handler.name
            )
        )
      }

      it 'does not change destination.handler' do
        expect {
          synchronize
        }.not_to change(destination, :handler)
      end
    end

    context 'without same attributes' do
      let(:destination) {
        Metasploit::Cache::Payload::Single::Unhandled::Instance.new
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

      let(:source) {
        double(
            'single payload Metasploit Module instance',
            handler_klass: double(
                'Metasploit Handler Module',
                general_handler_type: general_handler_type,
                handler_type: handler_type,
                name: name
            )
        )
      }

      context 'with existing Metasploit::Cache::Payload::Handler' do
        let!(:existing_payload_handler) {
          FactoryGirl.create(
              :metasploit_cache_payload_handler,
              general_handler_type: general_handler_type,
              handler_type: handler_type,
              name: name
          )
        }

        it 'changes destination.handler to existing Metasploit::Cache::Payload::Handler' do
          expect {
            synchronize
          }.to change(destination, :handler).to(existing_payload_handler)
        end
      end

      context 'without existing Metasploit::Cache::Payload::Handler' do
        it 'changes destination.handler' do
          expect {
            synchronize
          }.to change(destination, :handler)
        end

        context 'destination.handler' do
          subject(:destination_handler) {
            destination.handler
          }

          #
          # Callbacks
          #

          before(:each) do
            synchronize
          end

          it { is_expected.to be_persisted }

          it 'has source.handler_klass.general_handler_type for #general_handler_type' do
            expect(destination_handler.general_handler_type).to eq(source.handler_klass.general_handler_type)
          end

          it 'has source.handler_klass.handler_type for #handler_type' do
            expect(destination_handler.handler_type).to eq(source.handler_klass.handler_type)
          end
        end
      end
    end
  end
end