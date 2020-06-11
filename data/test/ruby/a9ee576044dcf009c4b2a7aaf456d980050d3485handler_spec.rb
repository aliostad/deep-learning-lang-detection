# -*- coding: utf-8 -*-
require 'spec_helper'

describe Eter::Node::Handler, "register" do

  class DummyHandler < Eter::Node::Handler; end
  class Eter::Node::Handler::Dummy < Eter::Node::Handler; end

  it "不明なテンプレートタグの時 nil を返すこと" do
    Eter::Node::Handler.get('mytag').should be_nil
  end

  it "#set(tagname, handler_class)" do
    Eter::Node::Handler.set('mytag', DummyHandler)
    Eter::Node::Handler.get('mytag').should == DummyHandler
  end
  
  it "#setの表記揺れを許容すること" do
    Eter::Node::Handler.set(:mytag1, DummyHandler)
    Eter::Node::Handler.get('mytag1').should == DummyHandler

    Eter::Node::Handler.set('mytag2', DummyHandler)
    Eter::Node::Handler.get(:mytag2).should == DummyHandler

    Eter::Node::Handler.set(:MyTag3, DummyHandler)
    Eter::Node::Handler.get(:mytag3).should == DummyHandler

    Eter::Node::Handler.set('MyTag4', DummyHandler)
    Eter::Node::Handler.get('mytag4').should == DummyHandler

    Eter::Node::Handler.set(:mytag5, DummyHandler)
    Eter::Node::Handler.get('MyTag5').should == DummyHandler
  end

  it "クラス名から自動ロードすること" do
    Eter::Node::Handler.get('dummy').should == Eter::Node::Handler::Dummy
  end

end
