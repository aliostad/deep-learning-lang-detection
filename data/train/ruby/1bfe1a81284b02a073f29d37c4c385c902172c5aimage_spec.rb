require_relative "../../../spec_helper.rb"

describe Chunks::Media::Image do
  describe "validation" do
    it "requires a title" do
      chunk = FactoryGirl.build(:image, title: nil)
      chunk.should_not be_valid
      chunk.title = "Some text"
      chunk.should be_valid
    end
  end
  
  it "is only previewable after an image has been uploaded" do
    chunk = FactoryGirl.build(:image, image_file_name: nil)
    chunk.should_not be_previewable
    chunk.image_file_name = "/some/file.png"
    chunk.should be_previewable
  end
end