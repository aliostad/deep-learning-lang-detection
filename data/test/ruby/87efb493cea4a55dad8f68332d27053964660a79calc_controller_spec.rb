require 'spec_helper'

describe CalcController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST 'calculate'" do
    it "returns http success" do
      post :calculate, :remote => true, :format => 'js'
      response.should be_success
      expect(response).to render_template("calculate")
    end

    it "1 + blank" do
      post :calculate, :expr1 => '1', :action_operator => '+', :remote => true, :format => 'js'
      assigns(:result).should == 1
    end

    it "blank + blank" do
      post :calculate, :action_operator => '+', :remote => true, :format => 'js'
      assigns(:result).should == 0
    end

    it "unknown operation" do
      post :calculate, :expr1 => '1', :action_operator => 'unknown123', :remote => true, :format => 'js'
      assigns(:result).should == 0
    end

    it "error 1 / 0" do
      post :calculate, :expr1 => '1', :expr2 => '0', :action_operator => '/', :remote => true, :format => 'js'
      assigns(:result).should == Float::INFINITY
    end

    it "returns 1 + 2" do
      post :calculate, :expr1 => '1', :expr2 => '2', :action_operator => '+', :remote => true, :format => 'js'
      assigns(:result).should == 3
    end

    it "returns 1 - 2" do
      post :calculate, :expr1 => '1', :expr2 => '2', :action_operator => '-', :remote => true, :format => 'js'
      assigns(:result).should == -1
    end

    it "returns 1 / 2" do
      post :calculate, :expr1 => '1', :expr2 => '2', :action_operator => '/', :remote => true, :format => 'js'
      assigns(:result).should == 0.5
    end

    it "returns √100" do
      post :calculate, :expr1 => '100', :action_operator => '√', :remote => true, :format => 'js'
      assigns(:result).should == 10
    end

    it "returns ∛27" do
      post :calculate, :expr1 => '27', :action_operator => '∛', :remote => true, :format => 'js'
      assigns(:result).should == 3
    end

    it "returns sin 1" do
      post :calculate, :expr1 => '1', :action_operator => 'sin', :remote => true, :format => 'js'
      assigns(:result).should == 0.8414709848078965
    end

    it "returns cos 1" do
      post :calculate, :expr1 => '1', :action_operator => 'cos', :remote => true, :format => 'js'
      assigns(:result).should == 0.5403023058681398
    end
  end
end
