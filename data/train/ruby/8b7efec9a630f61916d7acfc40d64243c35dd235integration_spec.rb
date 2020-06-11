# -*- encoding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'

require 'japanize'

describe "Japanization" do

  describe String do
    it "must calculate single math operation at japanize" do
      "１　に　２　を　たす".japanize.must_equal 3
    end
  end
  
  it "must calculate single math operation" do
     (１　に　２　を　たす).must_equal 3
  end
  
  it "must calculate compound math operation" do
    (１　に　２　を　たし　て　３　を　かける).must_equal 9
  end
  
  it "must calculate compound math operation　phrase" do
    (１に２をたして３をかける).must_equal 9
  end
  
end