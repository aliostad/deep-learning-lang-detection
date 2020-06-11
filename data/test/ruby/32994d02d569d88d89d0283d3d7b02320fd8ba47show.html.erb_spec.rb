require 'spec_helper'

describe "/chunks/show.html.erb" do
  include ChunksHelper
  before(:each) do
    assigns[:chunk] = @chunk = Factory(:chunk, :completion_rate => 0.8)
  end

  it "renders attributes in description" do
    render
    response.should have_tag("div[class=description]", /#{I18n.localize(@chunk.begin)}/)
  end

  it "should display a link_to_download_chunk in actions" do
    template.should_receive(:link_to_download_chunk).with(@chunk).and_return("<a href='/chunks/#{@chunk.id}'></a>")
    render
    response.should have_tag("div[class=actions]") do 
      with_tag("a[href=?]", "/chunks/#{@chunk.id}")
    end
  end

  it "should display Chunk#begin with seconds" do
    @chunk.begin = Time.zone.parse("20:30:17")
    render
    response.should have_text(/20:30:17/)
  end

  it "should display Chunk#end with seconds" do
    @chunk.end = Time.zone.parse("20:30:17")
    render
    response.should have_text(/20:30:17/)
  end

  it "should show vorbis format when the chunk format is vorbis" do
    @chunk.format = :vorbis
    render
    response.should have_text(/Ogg/)
  end

end
