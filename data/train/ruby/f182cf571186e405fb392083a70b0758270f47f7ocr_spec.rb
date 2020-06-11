require File.expand_path(File.dirname(__FILE__) + "/../lib/ocr")

describe OCR do
  
  before(:each) do
    @ocr = OCR.new
  end
  
  it "should parse number three" do
    chunk = [" _ ",
             " _|",
             " _|"]
    @ocr.parse(chunk).should == 3
  end

  it "should parse number 7" do
    chunk = [" _ ",
             "  |",
             "  |"]
    @ocr.parse(chunk).should == 7
  end

  it "should not parse unknown number" do
    chunk = [" _ ",
             " _ ",
             " _ "]
    @ocr.parse(chunk).should == "?"
  end
  
  it "should parse sequence of numbers" do
    chunk = ["    _  _     _  _  _  _  _ ",
             "  | _| _||_||_ |_   ||_||_|",
             "  ||_  _|  | _||_|  ||_| _|" ]
    @ocr.parseAll(chunk).should == [1,2,3,4,5,6,7,8,9]
  end
  
  it "should parse partial sequence of numbers" do
    chunk = ["    _  _     _  _  _  _  _ ",
             "  | _| _||_| - |_   ||_|| |",
             "  ||_  _|  | _ |_|  ||_||_|" ]
    @ocr.parseAll(chunk).should == [1,2,3,4,"?",6,7,8,0]
  end
end
