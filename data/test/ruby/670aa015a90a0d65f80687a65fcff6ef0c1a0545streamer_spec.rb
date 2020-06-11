require 'spec_helper'

describe River::Streamer do
  describe '#each' do
    subject{ result }

    let(:result){ [] }
    let(:batch_options){{}}
    let(:scope){ double(:scope) }
    let(:chunks){ ['first chunk', 'second chunk', 'last chunk'] }

    before do
      scope.should_receive(:find_in_batches).with(batch_options).tap do |stubbing|
        chunks.each do |chunk|
          stubbing = stubbing.and_yield(chunk)
        end
      end
      streamer.each{|r| result << r}
    end

    context 'with chunked option' do
      let(:streamer){ River::Streamer.new(scope, chunked: true) }

      it{ should eq(["d\r\n\"first chunk\"\r\n", "e\r\n\"second chunk\"\r\n", "c\r\n\"last chunk\"\r\n", "0\r\n\r\n"])}
    end

    context 'without chunked option' do
      let(:streamer){ River::Streamer.new(scope) }

      it{ should eq(["[", "\"first chunk\"", ",\"second chunk\"", ",\"last chunk\"", "]"])}
    end

    context 'with harmful batch options' do
      let(:batch_options){ { batch_size: 100 } }
      let(:streamer){ River::Streamer.new(scope, limit: 100, order: 'order', batch_size: 100) }

      it{ should eq(["[", "\"first chunk\"", ",\"second chunk\"", ",\"last chunk\"", "]"])}
    end

    context 'with harmful batch options and chunked option' do
      let(:batch_options){ { batch_size: 100 } }
      let(:streamer){ River::Streamer.new(scope, chunked: true, limit: 100, order: 'order', batch_size: 100) }

      it{ should eq(["d\r\n\"first chunk\"\r\n", "e\r\n\"second chunk\"\r\n", "c\r\n\"last chunk\"\r\n", "0\r\n\r\n"])}
    end
  end
end
