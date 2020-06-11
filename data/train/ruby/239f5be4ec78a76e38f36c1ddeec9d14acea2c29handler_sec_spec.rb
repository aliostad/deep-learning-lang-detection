require 'jpts_extractor/handler/handler'
require 'jpts_extractor/exceptions'

RSpec.describe JPTSExtractor::Handler::Handler do

  let(:handler) { JPTSExtractor::Handler::Handler.new }

  describe 'article handling' do
    describe '#start_element' do
      it 'pushes a FrontHandler onto the stack on event :sec' do
        handler.start_element(:sec)
        expect(handler.stack.top.class).to eq(JPTSExtractor::Handler::SectionHandler)
      end
    end

    describe '#end_element' do
      it 'raises a NullHandlerError' do
        expect {handler.end_element(:sec)}
          .to raise_error(JPTSExtractor::Exceptions::NullHandlerError)
      end

      it 'raises a BadParseError' do
        handler.start_element(:article)
        expect {handler.end_element(:sec)}
          .to raise_error(JPTSExtractor::Exceptions::BadParseError)
      end

      it 'raises a BadParseError' do
        handler.start_element(:sec)
        expect {handler.end_element(:sec)}
          .to raise_error(JPTSExtractor::Exceptions::BadParseError)
      end

      it 'raises a BadParseError' do
        handler.start_element(:front)
        handler.start_element(:sec)
        expect {handler.end_element(:sec)}
          .to raise_error(JPTSExtractor::Exceptions::BadParseError)
      end

      it 'adds a section to the body' do
        handler.start_element(:body)
        handler.start_element(:sec)
        handler.start_element(:title)
        handler.text('I Have Been In You')
        handler.end_element(:title)
        expect(handler.stack.top.class).to be(JPTSExtractor::Handler::SectionHandler)
        handler.end_element(:sec)
        expect(handler.stack.top.class).to be(JPTSExtractor::Handler::BodyHandler)
      end

      it 'adds a section to the section (nesting)' do
        handler.start_element(:body)
        handler.start_element(:sec)
        handler.start_element(:title)
        handler.text('I Have Benn In You')
        handler.end_element(:title)
        expect(handler.stack.top.class).to be(JPTSExtractor::Handler::SectionHandler)
        handler.start_element(:sec)
        handler.start_element(:title)
        handler.text('Rat Tomago')
        handler.end_element(:title)
        handler.end_element(:sec)
        expect(handler.stack.top.class).to be(JPTSExtractor::Handler::SectionHandler)
        handler.end_element(:sec)
        expect(handler.stack.top.class).to be(JPTSExtractor::Handler::BodyHandler)
      end
    end

  end
end

