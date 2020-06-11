require 'jpts_extractor/handler/handler'
require 'jpts_extractor/exceptions'

RSpec.describe JPTSExtractor::Handler::Handler do

  let(:handler) { JPTSExtractor::Handler::Handler.new }

  describe 'article handling' do
    describe '#start_element' do
      it 'pushes a AbstractHandler onto the stack on event :\'journal-meta\'' do
        handler.start_element(:abstract)
        expect(handler.stack.top.class).to eq(JPTSExtractor::Handler::AbstractHandler)
      end
    end

    describe '#end_element' do
      it 'raises a NullHandlerError' do
        expect {handler.end_element(:abstract)}
          .to raise_error(JPTSExtractor::Exceptions::NullHandlerError)
      end

      it 'raises a BadParseError' do
        handler.start_element(:article)
        expect {handler.end_element(:abstract)}
          .to raise_error(JPTSExtractor::Exceptions::BadParseError)
      end

      it 'raises a BadParseError' do
        handler.start_element(:abstract)
        expect {handler.end_element(:abstract)}
          .to raise_error(JPTSExtractor::Exceptions::BadParseError)
      end

      it 'raises a BadParseError' do
        handler.start_element(:article)
        handler.start_element(:abstract)
        expect {handler.end_element(:abstract)}
          .to raise_error(JPTSExtractor::Exceptions::BadParseError)
      end
    end
  end
end
