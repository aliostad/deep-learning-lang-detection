require 'spec_helper'

describe "/chunks/index.html.erb" do
  include ChunksHelper

  before(:each) do
    assigns[:chunks] = @chunks = Array.new(2) {
      Factory(:chunk, :completion_rate => 0.8, :source => Factory(:source))
    }
    assigns[:source] = @source = Factory(:source)
  end

  it "renders a list of chunks" do
    render
    response.should have_tag("h3", @chunks.first.title)
  end

  it "should use link_to_download_chunk for each Chunk" do
    @chunks.each do |chunk|
      template.should_receive(:link_to_download_chunk).with(chunk).and_return("<a href='/chunks/#{chunk.id}'></a>")
    end

    render

    @chunks.each do |chunk|
      response.should have_tag("div[class=actions]") do 
        with_tag("a[href=?]", "/chunks/#{chunk.id}")
      end
    end
  end
end
